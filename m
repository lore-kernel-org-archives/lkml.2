Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab1DVWgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 18:36:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:55160 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab1DVWf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 18:35:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,256,1301900400"; 
   d="scan'208";a="737231505"
From: james_p_freyensee@linux.intel.com
To: akpm@linux-foundation.org
Cc: rientjes@google.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com, christophe.guerard@intel.com,
        james_p_freyensee@linux.intel.com
Subject: Resend: export kernel call get_task_comm for driver use
Date: Fri, 22 Apr 2011 15:35:43 -0700
Message-Id: <1303511744-815-1-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend: Sorry, I misspelled the email address of the main
person I want this patch directed to.

>From an earlier submission by me it was suggested that this patch
should go to Andrew for merging to be used by the pti driver
I will be re-submitting shortly.

Once my device drivers are accepted into the kernel, I will try
and help out to clean up the kernel a little from this
patch that exports get_task_comm() that Andrew suggested. 
I cannot promise a timeline or what I can fix, but I will
look into fixing a few (Andrew found 89 potential cleanups).

From: james_p_freyensee@linux.intel.com
Subject: Resend: export kernel call get_task_comm for driver use
In-Reply-To: james_p_freyensee@linux.intel.com

