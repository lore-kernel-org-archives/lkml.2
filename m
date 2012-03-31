Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095Ab2CaOKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 10:10:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:52127 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486Ab2CaOK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 10:10:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83844378"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: tim.c.chen@linux.intel.com, linux-mm@kvack.org
Subject: Huge page counter speedup complete
Date: Sat, 31 Mar 2012 07:09:55 -0700
Message-Id: <1333202997-19550-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate some hot cache lines in mm_struct for THP that showed up
in profiling.

This is a two patch patchkit, but the earlier submission only included
one. No code changes. Sorry about that.

-Andi

