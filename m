Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab0E1HkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:40:06 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:54074 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab0E1HkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:40:00 -0400
Subject: [GIT PULL] LED bigfix for 2.6.3r-rc1
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 08:39:29 +0100
Message-ID: <1275032369.24079.1464.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for a couple of LED bugfixes 2.6.35-rc1. There were a couple of issues
that showed up on ppc.

Thanks, Richard

 drivers/leds/Kconfig     |    6 +++---
 drivers/leds/leds-gpio.c |    1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

Richard Purdie (2):
      leds: Kconfig fixes
      leds: Fix leds-gpio openfirmware compile issue

-- 
Richard Purdie
Intel Open Source Technology Centre


