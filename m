Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2GGBtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 21:49:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2GGBtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 21:49:19 -0400
From: "Du Changbin" <changbin.du@gmail.com>
To: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>
Cc: <mchehab@infradead.org>, <anssi.hannula@iki.fi>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Resend PATCH] media: rc: ati_remote.c: code style and compile warning fixing
Date: Sat, 7 Jul 2012 09:49:11 +0800
Message-ID: <031601cd5be2$b8831fb0$29895f10$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
thread-index: Ac1b4rMqPqfKRinISF2591d4QKd1yA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/drivers/media/rc/ati_remote.c
b/drivers/media/rc/ati_remote.c
> > index 7be377f..0df66ac 100644
> > --- a/drivers/media/rc/ati_remote.c
> > +++ b/drivers/media/rc/ati_remote.c
> > @@ -23,6 +23,8 @@
> >    *                Vincent Vanackere <vanackere@lif.univ-mrs.fr>
> >    *            Added support for the "Lola" remote contributed by:
> >    *                Seth Cohn <sethcohn@yahoo.com>
> > + *  Jul 2012: Du, Changbin <changbin.du@gmail.com>
> > + *            Code style and compile warning fixing
> 
> You shouldn't be changing the driver's authorship just due to codingstyle
> and warning fixes. Btw, Please split Coding Style form Compilation
warnings,
> as they're two different matters.

Sorry, I didn't know this rule. I just want to make  a track for me. OK, I
will resend this patch and remove me from it.
BTW, I am looking for something to learn these basic rules when sending
patches. Could you tell me where I can find it?
Many thanks!
[Du, Changbin]

> 
> Thanks!
> Mauro


