Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1G0VsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:23542 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab1G0Vr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:47:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900286"
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20110727247.325703029@firstfloor.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [0/99] 2.6.35.14 longterm review
Date: Wed, 27 Jul 2011 14:47:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the longterm review cycle for the 2.6.35.14 release.
There are a large number of patches in this series, which will be posted as a 
response to this one.  If anyone has any issues with these being applied, 
please let me know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

I'm posting the patches in 100 patch chunks to not overload the mailing
list. The next chunk will come tomorrow.

The full quilt queue can be found at
git://git.kernel.org/pub/scm/linux/kernel/git/longterm/longterm-queue-2.6.35

Responses should be made within 48 hours.

-Andi
