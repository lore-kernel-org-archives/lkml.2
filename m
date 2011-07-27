Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1G0Ae4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:34:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:54885 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab1G0Aew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:34:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="32659129"
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20110726534.972201586@firstfloor.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [0/98] 2.6.35.14 longterm review
Date: Tue, 26 Jul 2011 17:34:51 -0700 (PDT)
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
