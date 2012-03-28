Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab2C1Arn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:47:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:24083 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab2C1Ark (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:47:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124058217"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: spin-is-locked is evil patchkit v2
Date: Tue, 27 Mar 2012 17:47:04 -0700
Message-Id: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an updated patchkit to mostly exorcise spin_is_locked.
See 11/13 on why.

Now comes with a checkpatch rule and better documentation, and various
feedbacks on v1 were addressed. 

Should be ready for merging now.

-Andi

