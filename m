Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab0J1W1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:27:46 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:52160 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756969Ab0J1W1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:27:40 -0400
Message-ID: <4CC9F8D7.4070802@eukrea.com>
Date: Fri, 29 Oct 2010 00:27:35 +0200
From: =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Dinh.Nguyen@freescale.com, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: imx: Fix GPIO_1_xx settings that are wrongly assumed
References: <1288296137-1995-1-git-send-email-Dinh.Nguyen@freescale.com> <20101028205945.GE31158@pengutronix.de>
In-Reply-To: <20101028205945.GE31158@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 17931081918360366432
X-Ovh-Remote: 82.233.81.124 (tal33-3-82-233-81-124.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

Le 28/10/2010 22:59, Uwe Kleine-König a écrit :
 > Before b545d9ed1b92f169d0326afac091328be5e76620 the muxmode entries were
 > correct.  Back when I looked at the patch that resulted into b545d9ed1b9
 > I wondered if the intended change was only
 > s/NO_PAD_CTRL/MX51_GPIO_PAD_CTRL/ but didn't check the reference manual.
 >
 > Eric?
 >
GPIO_PAD_CTRL was the original wanted change for that patch and while looking 
at this I misread the iomux pages in the manual for gpio 2 to 9 which leads to 
the mux error.

BTW, Arnaud Patard already provided a fix to this in it's efikamx patch serie.

Eric
