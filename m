Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1HLDgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 23:36:04 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:42430 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab1HLDgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 23:36:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=kylemanna.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references; q=dns; s=
	kylemanna.com; b=nUWDq0it1Yn494xW8bAcu1n/Zc3X4zPujtkeRfC/BdRWWmG
	mtC6nqYIVxOWT6ueOZ73mM+tRJSmz0LMxlf/YC8IeHX5fam9jWwumF70f3fTDImV
	agaFLFJn167u8AK51cGvzHozFzHSyKUg1XI0aJjtR0adrUypfPRO+pjOwzwg=
From: Kyle Manna <kyle@kylemanna.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Keerthy <j-keerthy@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyle Manna <kyle@kylemanna.com>
Subject: [PATCH v2 0/4] Fixes to twl4030-madc and add BeagleBoard support
Date: Thu, 11 Aug 2011 22:33:11 -0500
Message-Id: <1313119995-15382-1-git-send-email-kyle@kylemanna.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <CANOLnOPB=wFMPwqGbu9ufh__iM7TquUx3-o95R=gyJcae+gENg@mail.gmail.com>
References: <CANOLnOPB=wFMPwqGbu9ufh__iM7TquUx3-o95R=gyJcae+gENg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add basic functionality to the twl4030-madc driver to make
it work on the BeagleBoard xM.

Version 2 adds fixes per Grazvydas Ignotas and the check for NULL pointer patch.

Kyle Manna (4):
  mfd: twl4030-madc: copy the device pointer
  mfd: twl4030-madc: turn on the MADC clock
  mfd: twl4030-madc: check for NULL pointer
  arm: BeagleBoard: add support for the twl4030-madc

 arch/arm/mach-omap2/board-omap3beagle.c |    9 ++++++++-
 drivers/mfd/twl4030-madc.c              |   27 ++++++++++++++++++++++++++-
 include/linux/i2c/twl4030-madc.h        |    4 ++++
 3 files changed, 38 insertions(+), 2 deletions(-)

-- 
1.7.4.1

