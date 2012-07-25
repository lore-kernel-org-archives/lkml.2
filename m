Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab2GYLn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:43:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:37851 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523Ab2GYLnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:43:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="185825264"
Date: Wed, 25 Jul 2012 19:05:23 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: bcma_bus_scan/bcma_bus_scan_early: missing iounmap
Message-ID: <20120725110523.GA24514@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hauke,

The coccinelle static checker emits these warnings:

drivers/bcma/scan.c:466:3-9: ERROR: missing iounmap; ioremap on line 451 and execution via conditional on line 465
drivers/bcma/scan.c:540:3-9: ERROR: missing iounmap; ioremap on line 515 and execution via conditional on line 539

It seems we need to change the return statements to goto/break statements.

Thanks,
Fengguang
