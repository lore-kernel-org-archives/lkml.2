Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab2KFNMC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:12:02 -0500
Received: from mga14.intel.com ([143.182.124.37]:55294 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab2KFNMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:12:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,722,1344236400"; 
   d="scan'208";a="165055808"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
Cc: gregkh@linuxfoundation.org, andre.przywara@amd.com, alex.shi@intel.com,
        rjw@sisk.pl, paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, cl@linux.com,
        pjt@google.com
Subject: [RFC PATCH 0/3] power aware scheduling
Date: Tue,  6 Nov 2012 21:09:56 +0800
Message-Id: <1352207399-29497-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implement my previous power aware scheduling proposal:
https://lkml.org/lkml/2012/8/13/139

It base on tip/master tree, 
It also resused much of old code from Suresh in 2nd patch. I don't know
to give credit to Suresh for this.
Suresh, could you like to give 'signed-off' or sth you think needed?

Appreciate for any comments!

Regards!
Alex

