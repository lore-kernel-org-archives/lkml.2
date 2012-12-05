Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2LENXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 08:23:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53788 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab2LENW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 08:22:58 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 3/4] sta2x11_vip: convert to videobuf2 and control framework
Date: Wed, 05 Dec 2012 14:27:35 +0100
Message-ID: <1773237.zC2M0dmkYp@harkonnen>
User-Agent: KMail/4.9.3 (Linux/3.6.8-2.fc17.x86_64; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50BF47CA.5070205@redhat.com>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com> <2637992.xolQO8ly5c@harkonnen> <50BF47CA.5070205@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ok, I understand. I will write something like this.
> > 
> >   * Copyright (C) 2012       ST Microelectronics
> >   *      author: Federico Vaga <federico.vaga@gmail.com>
> >   * Copyright (C) 2010       WindRiver Systems, Inc.
> >   *      authors: Andreas Kies <andreas.kies@windriver.com>
> >   *               Vlad Lungu <vlad.lungu@windriver.com>
> 
> Sounds perfect to me.

I will answer to this with a patch

> As you said, the best place to discuss about it is likely at LKML.
> [...]
> Btw, this is why it is called "git blame", and not "git authorship":
> it is a tool to identify who was the last one that modified the code.
> Its main usage is to identify who might have introduced a bug on the
> code.

I know I know, it was just a stupid example to expose the problem that I have 
in my mind. I know that it is very difficult (impossible?) to assign the 
authorship of a single line, and git blame it is not the tool to do this :)

I think you understand what I mean despite the stupid example

-- 
Federico Vaga
