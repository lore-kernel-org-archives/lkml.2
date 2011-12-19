Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1LSWr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:47:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:27694 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab1LSWry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:47:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98090047"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, trenn@suse.de, kay.sievers@vrf.org
Subject: Updated cpuid-match patchkit v2
Date: Mon, 19 Dec 2011 14:47:36 -0800
Message-Id: <1324334865-30459-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchkit allows automatic udev loading of drivers based on x86
CPUID models and feature ids.

This version addresses the review feedback, except:
- no multi match to keep things simple
- only matches boot cpu (also to make it simple)

I changed all the tables to const and did some other improvements.

More testing still appreciated, especially in a real distribution.

-Andi

