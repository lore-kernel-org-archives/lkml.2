Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2FLFXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 01:23:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:11915 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab2FLFXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 01:23:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164447749"
Date: Tue, 12 Jun 2012 13:22:58 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm/page-writeback.c: fix comment error
Message-ID: <20120612052258.GA12134@localhost>
References: <1339478103-8748-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339478103-8748-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	 * However to get a more stable dirty_ratelimit, the below elaborated
> -	 * code makes use of task_ratelimit to filter out sigular points and
> +	 * code makes use of task_ratelimit to filter out singular points and
>  	 * limit the step size.

I've fixed this btw in the previous comment fixing patch :)
Thanks anyway!

Fengguang
