Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab2DKTkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:40:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:24742 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004Ab2DKTkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:40:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="131319267"
From: Jim Kukunas <james.t.kukunas@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, hpa@zytor.com
Subject: lib/raid6: SSSE3 optimized recovery functions v2
Date: Wed, 11 Apr 2012 12:40:27 -0700
Message-Id: <1334173231-28595-1-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

The following patchset adds SSSE3 optimized recovery
functions to RAID6.

This version differs from version 1, in that:
        0) cpu_has_ssse3 is moved to within the #ifdef block
	1) the functions are moved into their own file, recov_ssse3.c
	2) a superfluous memory load is removed from raid6_2data_recov_ssse3

A technical description of the algorithm can be found
at http://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf

Thanks.


