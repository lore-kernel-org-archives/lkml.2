Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1LSXqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:46:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:16645 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab1LSXqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:46:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="89277669"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, trenn@suse.de, kay.sievers@vrf.org
Subject: CPUID based driver autoloading v3
Date: Mon, 19 Dec 2011 15:46:26 -0800
Message-Id: <1324338394-4670-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Automatically load drivers based on the x86 cpuid.

I made some mistake in the last post with missing patches and wrong
numbering. Here's a v3 that should be better.

The only code change is the removal of the Cyrix CPUID match as
Dave Jones suggested.

-Andi

