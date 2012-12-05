Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2LEMTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:19:46 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53924 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2LEMTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:19:44 -0500
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
Date: Wed, 05 Dec 2012 13:24:20 +0100
Message-ID: <2637992.xolQO8ly5c@harkonnen>
User-Agent: KMail/4.9.3 (Linux/3.6.8-2.fc17.x86_64; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50BF315C.8090203@redhat.com>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com> <8113379.Pqy1l62Utl@number-5> <50BF315C.8090203@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Mauro for the good explanation

> Yeah, there are many changes there that justifies adding you at its
> authorship, and that's ok. Also, anyone saying the size of your patch
> will recognize your and ST efforts to improve the driver.
> 
> However, as some parts of the code were preserved, dropping the old
> authors doesn't sound right (and can even be illegal, in the light
> of the GPL license). It would be ok, though, if you would be
> changing it to something like:
> 
> 	Copyright (c) 2010 by ...
> or
> 	Original driver from ...

Ok, I understand. I will write something like this.
 * Copyright (C) 2012       ST Microelectronics
 *      author: Federico Vaga <federico.vaga@gmail.com>
 * Copyright (C) 2010       WindRiver Systems, Inc.
 *      authors: Andreas Kies <andreas.kies@windriver.com>
 *               Vlad Lungu <vlad.lungu@windriver.com>


> The only way of not preserving the original authors here were if you
> start from scratch, without looking at the original code (and you can
> somehow, be able to proof it), otherwise, the code will be fit as a
> "derivative work", in the light of GPL, and should be preserving the
> original authorship.
> 
> Something started from scratch like that will hardly be accepted upstream,
> as regressions will likely be introduced, and previously supported
> hardware/features may be lost in the process.

I understand
 
> Of course the original author can abdicate to his rights of keeping his
> name on it. Yet, even if he opt/accept to not keep his name explicitly
> there, his copyrights are preserved, with the help of the git history.
> 
> That's said, no single kernel developer/company has full copyrights on
> any part of the Kernel, as their code are based on someone else's work.
> For example, all Kernel drivers depend on drivers/base, with in turn,
> depends on memory management, generic helper functions, arch code, etc.

yeah I know :)

> So, IMHO, there's not much point on dropping authorship messages.

So the MODULE_AUTHOR will be Windriver forever until they drop authorship? 
Also if in the next future 0 windriver lines will be in the code?

(general talking, not about this driver)
If I do git blame on a driver with MODULE_AUTHOR("Mr. X"); but only the 
MODULE_AUTHOR line is from Mr X; there is not an automatically system which 
remove the MODULE_AUTHOR? Ok, probably it was the original author of the code 
and the comment header with the copyright history gives to Mr X all the 
honours, but there is nothing from him in the code. It is not better to remove 
MODULE_AUTHOR or replace it with who wrotes most of the code?
I know that this is not the best place to talk about this, just a little 
curiosity

-- 
Federico Vaga
