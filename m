Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937365Ab0CPBlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:41:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:1417 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833Ab0CPBlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:41:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,647,1262592000"; 
   d="scan'208";a="781089466"
Message-Id: <20100316013653.367442879@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 16 Mar 2010 09:36:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] O_* bit numbers uniqueness check patches (V2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Please take these 3 patches. They are against todays's mmotm.

Sorry for the confusion!

Note that the FMODE_EXEC change is moved as the last one, so that when
removing FMODE_EXEC from the O_* namespace, the commit can be simply
reverted.

Thanks,
Fengguang

