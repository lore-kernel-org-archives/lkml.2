Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab0LMHbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 02:31:01 -0500
Received: from mail.karo-electronics.de ([213.146.116.110]:33944 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab0LMHbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 02:31:00 -0500
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2010 02:30:59 EST
Message-ID: <19717.51684.567190.925646@ipc1.ka-ro>
Date: Mon, 13 Dec 2010 08:23:16 +0100
From: =?iso-8859-15?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
To: Liu Ying <liu.y.victor@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, linux-fbdev@vger.kernel.org,
        Zhang Lily-R58066 <r58066@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 5/9] Add i.MX5 framebuffer driver
In-Reply-To: <AANLkTikZowDCK4JPiCyEou1ekRuYA1qGnKrBPT5dXB+8@mail.gmail.com>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de>
	<1291902441-24712-6-git-send-email-s.hauer@pengutronix.de>
	<AANLkTikZowDCK4JPiCyEou1ekRuYA1qGnKrBPT5dXB+8@mail.gmail.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Liu Ying writes:
> 6) I prefer to find the video mode in modedb first, and if we cannot
> find the video mode in common video mode data base, we can find a
> video mode in custom video mode data base which is defined in platform
> data. In this way, we don't need to export common modefb.
> 
IMO platform specific video modes should take precedence over generic
ones, so the platform data should be evaluated first.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
