Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab0LMLfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 06:35:12 -0500
Received: from mail-iw0-f170.google.com ([209.85.214.170]:47169 "EHLO
	mail-iw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab0LMLfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 06:35:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AoCTgWYWsOgHEEhcO0aTaDkSTDeTP+W/BTYEtLBkRFc3EJ5P7IBzTuB/Th5mgHf5T4
         o4Sr/b6qnvprWSbzXe1sH5AIleH+Vv5xMgu7cY04DlwdYuTySmr+qZ0aZeZMJ+u1v49F
         9mdiumdOTPOCZ1WYP3lx0F6v0Jd46NjvMfYrI=
MIME-Version: 1.0
In-Reply-To: <19717.51684.567190.925646@ipc1.ka-ro>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de>
	<1291902441-24712-6-git-send-email-s.hauer@pengutronix.de>
	<AANLkTikZowDCK4JPiCyEou1ekRuYA1qGnKrBPT5dXB+8@mail.gmail.com>
	<19717.51684.567190.925646@ipc1.ka-ro>
Date: Mon, 13 Dec 2010 19:35:08 +0800
Message-ID: <AANLkTi=muPnjbJb9P9XSDnQJNjUSqRf-4F0sTf2WUNqR@mail.gmail.com>
Subject: Re: [PATCH 5/9] Add i.MX5 framebuffer driver
From: Liu Ying <liu.y.victor@gmail.com>
To: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, linux-fbdev@vger.kernel.org,
        Zhang Lily-R58066 <r58066@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lothar Waﬂmann,

I think your opinion is reasonable and better.
So, first, we can find the video mode in the video mode data base
defined in platform data, and then, if this fails, we can find it in
common video mode data base.

Best Regards,
Liu Ying

2010/12/13 Lothar Waﬂmann <LW@karo-electronics.de>:
> Hi,
>
> Liu Ying writes:
>> 6) I prefer to find the video mode in modedb first, and if we cannot
>> find the video mode in common video mode data base, we can find a
>> video mode in custom video mode data base which is defined in platform
>> data. In this way, we don't need to export common modefb.
>>
> IMO platform specific video modes should take precedence over generic
> ones, so the platform data should be evaluated first.
>
>
> Lothar Waﬂmann
> --
> ___________________________________________________________
>
> Ka-Ro electronics GmbH | Pascalstraﬂe 22 | D - 52076 Aachen
> Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
> Gesch‰ftsf¸hrer: Matthias Kaussen
> Handelsregistereintrag: Amtsgericht Aachen, HRB 4996
>
> www.karo-electronics.de | info@karo-electronics.de
> ___________________________________________________________
>
