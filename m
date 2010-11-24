Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0KXToK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:44:10 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39197 "EHLO deliverator"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752960Ab0KXToJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:44:09 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 00/12] SEP cleanups
To: greg@kroah.com, mark.a.allyn@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Nov 2010 19:23:46 +0000
Message-ID: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a rework from the bits I sent you a while back Mark (which I suspect
got eaten in the email) and some other cleanup. I've not beaten it up with
CodingStyle yet because most of the debug wants removing before that is done
so it is probably more productive to fix the logic and the inherited choice of
TRUELY_GIANT_DEFINE_NAMES_THAT_CAUSE_MUCH_WRAPPING before we worry about finer
points of style.

---

Alan Cox (12):
      sep: Fix crash if a device is not found
      sep: clean up a couple of spots missed in pass one
      sep: cant is an angular inclination
      sep: Make SEP consistent
      sep: Use kzalloc when needed
      sep: clean up some of the obvious sillies
      sep: Fix the kernel-doc in SEP
      sep: clean up caller_id function
      sep: netlink - what netlink
      sep: handle the memrar stuff in the headers
      sep: handle the rar definition stuff in the header
      sep: minimal fix for wrong include


 drivers/staging/memrar/memrar.h         |   19 
 drivers/staging/sep/sep_driver.c        | 2230 ++++++++++++-------------------
 drivers/staging/sep/sep_driver_config.h |  194 ---
 include/linux/rar_register.h            |   16 
 4 files changed, 902 insertions(+), 1557 deletions(-)

-- 
