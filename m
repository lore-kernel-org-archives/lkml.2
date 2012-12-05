Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab2LEBMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:12:38 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56054 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2LEBMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:12:35 -0500
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
Date: Wed, 05 Dec 2012 02:12:24 +0100
Message-ID: <8113379.Pqy1l62Utl@number-5>
User-Agent: KMail/4.9.3 (Linux/3.6.8-2.fc17.x86_64; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50BE2193.4020103@redhat.com>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com> <1348484332-8106-3-git-send-email-federico.vaga@gmail.com> <50BE2193.4020103@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2012 14:15:15 Mauro Carvalho Chehab wrote:
> Em 24-09-2012 07:58, Federico Vaga escreveu:
> > This patch re-write the driver and use the videobuf2
> > interface instead of the old videobuf. Moreover, it uses also
> > the control framework which allows the driver to inherit
> > controls from its subdevice (ADV7180)
> > 
> > Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> > Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> >
> > [..........]
> > 
> >   /*
> >   
> >    * This is the driver for the STA2x11 Video Input Port.
> >    *
> > 
> > + * Copyright (C) 2012       ST Microelectronics
> > 
> >    * Copyright (C) 2010       WindRiver Systems, Inc.
> >    *
> >    * This program is free software; you can redistribute it and/or modify
> >    it
> > 
> > @@ -19,36 +20,30 @@
> > 
> >    * The full GNU General Public License is included in this distribution
> >    in
> >    * the file called "COPYING".
> >    *
> > 
> > - * Author: Andreas Kies <andreas.kies@windriver.com>
> > - *		Vlad Lungu <vlad.lungu@windriver.com>
> 
> Why are you dropping those authorship data?
> 
> Ok, it is clear to me that most of the code there got rewritten, and,
> while IANAL, I think they still have some copyrights on it.
> 
> So, if you're willing to do that, you need to get authors ack
> on such patch.

I re-write the driver, and also the first version of the driver has many 
modification made by me, many bug fix, style review, remove useless code.
The first time I didn't add myself as author because the logic of the driver 
did not change. This time, plus the old change I think there is nothing of the 
original driver because I rewrite it from the hardware manual. Practically, It 
is a new driver for the same device.

Anyway I will try to contact the original authors for the acked-by.

> >   MODULE_DESCRIPTION("STA2X11 Video Input Port driver");
> > 
> > -MODULE_AUTHOR("Wind River");
> 
> Same note applies here: we need Wind River's ack on that to drop it.

I will try also for this. But I think that this is not a windriver driver 
because I re-wrote it from the hardware manual. I used the old driver because 
I thought that it was better than propose a patch that remove the old driver 
and add my driver.
I did not remove the 2010 Copyright from windriver, because they did the job, 
but this work was paid by ST (copyright 2012) and made completely by me.

Is my thinking wrong?

Just a question for the future so I avoid to redo the same error. If I re-
wrote most of a driver I cannot change the authorship automatically without 
the acked-by of the previous author. If I ask to the previous author and he 
does not give me the acked-by (or he is unreachable, he change email address), 
then the driver is written by me but the author is someone else? Right? So, it 
is better if I propose a patch which remove a driver and a patch which add my 
driver?

Thank you

-- 
Federico Vaga
