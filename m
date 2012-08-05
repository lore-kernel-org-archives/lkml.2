Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2HEIep (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 04:34:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:29789 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab2HEIen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 04:34:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="193349696"
Message-Id: <20120805082614.071671796@intel.com>
User-Agent: quilt/0.51-1
Date: Sun, 05 Aug 2012 16:26:14 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
to: Jens Axboe <axboe@kernel.dk>
CC: Andrew Morton <akpm@linux-foundation.org>
cc: <linux-fsdevel@vger.kernel.org>
cc: Damien Wyart <damien.wyart@free.fr>
cc: Li Shaohua <shli@fusionio.com>
CC: Jeff Moyer <jmoyer@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] [RESEND] Remove plugging at buffered write time
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

It seems this patch was silently forgotten, but the review comments have all
been addressed: the patch has been split into two pieces and tests show no
performance regressions (nor noticeable gains..).

Thanks to Damien for reminding me of the patch!

Thanks,
Fengguang

