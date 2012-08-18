Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab2HRRa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:30:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:8308 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab2HRRa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="182354043"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Subject: Const section fixes tree sweep
Date: Sat, 18 Aug 2012 10:29:51 -0700
Message-Id: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tree sweep fixes up const section conflicts. Each section can 
either be read-write or read-only. Read-only sections can contain
only read-only (const) data, read-write only non const data.

This fixes this everywhere for x86 at least (and a few other
places found by grep) 

The previous version had some issues with a broken PA-RISC
toolchain. I disabled the whole thing on PA-RISC now instead.

Needed for followon patchkits.

-Andi

