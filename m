Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab2LENiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 08:38:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab2LENiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 08:38:10 -0500
Message-ID: <50BF4E25.3010207@redhat.com>
Date: Wed, 05 Dec 2012 11:37:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Federico Vaga <federico.vaga@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 3/4] sta2x11_vip: convert to videobuf2 and control
 framework
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com> <2637992.xolQO8ly5c@harkonnen> <50BF47CA.5070205@redhat.com> <1773237.zC2M0dmkYp@harkonnen>
In-Reply-To: <1773237.zC2M0dmkYp@harkonnen>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 05-12-2012 11:27, Federico Vaga escreveu:
>>> Ok, I understand. I will write something like this.
>>>
>>>    * Copyright (C) 2012       ST Microelectronics
>>>    *      author: Federico Vaga <federico.vaga@gmail.com>
>>>    * Copyright (C) 2010       WindRiver Systems, Inc.
>>>    *      authors: Andreas Kies <andreas.kies@windriver.com>
>>>    *               Vlad Lungu <vlad.lungu@windriver.com>
>>
>> Sounds perfect to me.
>
> I will answer to this with a patch

Thanks!

>> As you said, the best place to discuss about it is likely at LKML.
>> [...]
>> Btw, this is why it is called "git blame", and not "git authorship":
>> it is a tool to identify who was the last one that modified the code.
>> Its main usage is to identify who might have introduced a bug on the
>> code.
>
> I know I know, it was just a stupid example to expose the problem that I have
> in my mind. I know that it is very difficult (impossible?) to assign the
> authorship of a single line, and git blame it is not the tool to do this :)
>
> I think you understand what I mean despite the stupid example

Yeah, I hear you.

Not sure if you got my point: the main point of removing MODULE_AUTHOR
and other copyright stuff is that such patch may easily be doing something
that could be considered a copyright violation, being bad not only to
the affected driver, but to the entire Kernel.

So, we need to handle it with due care. Getting other authors's
acks on such patch seems to be the only safe way of doing that.

Regards,
Mauro

