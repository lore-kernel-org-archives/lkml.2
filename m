Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab2AHQV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:21:59 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45108 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753889Ab2AHQV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:21:58 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX196O+JmSoZ6OzbkD7VyuusOGIXMu12enm2Hj36tn0
	DmxWoiqUOdD2g5
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: unmet direct dependencies in v3.2-3023-g02550d6
Date: Sun, 8 Jan 2012 17:21:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.7.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201201081721.47441.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

a "make randconfig" gives :

warning: (HAVE_TEXT_POKE_SMP) selects STOP_MACHINE which has unmet direct dependencies (SMP && MODULE_UNLOAD || HOTPLUG_CPU)

warning: (IWM && WIMAX_IWMC3200_SDIO) selects IWMC3200TOP which has unmet direct dependencies (MISC_DEVICES && MMC && 
EXPERIMENTAL)

warning: (MEDIA_TUNER) selects MEDIA_TUNER_TEA5761 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_MEDIA && I2C && 
EXPERIMENTAL)


for the current git tree - are these issues already known ?


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
