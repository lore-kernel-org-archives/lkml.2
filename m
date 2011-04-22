Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab1DVW0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 18:26:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:15002 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786Ab1DVW0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 18:26:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,256,1301900400"; 
   d="scan'208,223";a="737228701"
From: james_p_freyensee@linux.intel.com
To: akpm@linux-foundattion.org
Cc: rientjes@google.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com, christophe.guerard@intel.com,
        james_p_freyensee@linux.intel.com
Subject: export kernel call get_task_comm for driver use
Date: Fri, 22 Apr 2011 15:26:27 -0700
Message-Id: <1303511188-728-1-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From an earlier submission by me it was suggested that this patch
should go to Andrew for merging to be used by the pti driver
I will be re-submitting shortly.

Once my device drivers are accepted into the kernel, I will try
and help out to clean up the kernel a little from this
patch that exports get_task_comm() that Andrew suggested. 
I cannot promise a timeline or what I can fix, but I will
look into fixing a few (Andrew found 89 potential cleanups).

From: james_p_freyensee@linux.intel.com
Subject: export kernel call get_task_comm for driver use
In-Reply-To: james_p_freyensee@linux.intel.com

