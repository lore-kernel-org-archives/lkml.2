Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162914Ab2GLXIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:08:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61954 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162890Ab2GLXID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:08:03 -0400
From: Marc Reilly <marc@cpdesign.com.au>
To: linux-arm-kernel@lists.infradead.org
Reply-To: Marc Reilly <marc@cpdesign.com.au>
Cc: Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Philippe =?ISO-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Subject: Re: [PATCH 0/7] Add support for Freescale's mc34708 to mc13xxx driver
Date: Fri, 13 Jul 2012 09:02:56 +1000
Message-ID: <11987916.rOoNGcb1ly@dev1>
Organization: Creative Product Design
User-Agent: KMail/4.8.4 (Linux/3.1.10-1.16-desktop; KDE/4.8.4; x86_64; ; )
In-Reply-To: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

> This series was tested on a Phytec pcm038 (mc13783 on spi) using
> traditional boot (i.e. not dt) and on a i.MX53 based machine (mc34708 on
> i2c) using dt boot.
> 
> Philippe's patches are already in next, they are just included here for
> those who want to test the patches. The 'mfd/mc13xxx: drop modifying
> driver's id_table in probe' was already sent out yesterday and is
> included here because the last patch depends on it.
> 

For all patches (that don't already have it):
Acked-by: Marc Reilly <marc@cpdesign.com.au>

If for some reason you do a V2:
- In patch 6 moves line "#define MC13XXX_NUMREGS 0x3f" around, is this 
necessary?
- Patch 4 should come last, ie after "add support for mc34708"

Cheers,
Marc
