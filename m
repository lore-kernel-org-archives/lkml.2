Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1E2JWI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 05:22:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53130 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750915Ab1E2JWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 05:22:05 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+TuFotlvWTKGsGEl+w8zTZB5EGTXIO6oG2eOGaBh
	wfrsGWhLAF4YyZ
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: 2 small kernel config issues related to UML + RTC
Date: Sun, 29 May 2011 11:22:01 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.7; KDE/4.6.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105291122.01602.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

with the current git kernel I run 
$>make ARCH=um menuconfig

and searched for the string "RTC" b/c during boot of my UML image I realized nowadays the message:

"Kernel not built with RTC support, ALARM timers will not wake from suspend"

Although the menuconfig gives me the answer :

  │ Symbol: STMMAC_RTC_TIMER [=n]                                                                                   │   
  │ Type  : boolean                                                                                                 │   
  │ Prompt: Real time clock                                                                                         │   
  │   Defined at drivers/net/stmmac/Kconfig:50                                                                      │   
  │   Depends on: <choice> && RTC_CLASS                                                                             │   
  │   Location:                                                                                                     │   
  │     -> Network device support (NETDEVICES [=y])                                                                 │   
  │       -> Ethernet (1000 Mbit) (NETDEV_1000 [=n])                                                                │   
  │         -> STMicroelectronics 10/100/1000 Ethernet driver (STMMAC_ETH [=n])                                     │   
  │           -> STMMAC Timer optimisation (STMMAC_TIMER [=n])                                                      │   
  │             -> Select Timer device (<choice> [=n])                                                              │   


I cannot found the menu item.

To sum it up IMO the kernel mesage doesn't makes sense for UML
and furthermore searching for "RTC" shouldn't give non-existent menu items, isn't it ?


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
