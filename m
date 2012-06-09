Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2FILKO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 07:10:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:36266 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2FILKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 07:10:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163325845"
Date: Sat, 9 Jun 2012 19:10:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix some comments error in writeback subsystem
Message-ID: <20120609111008.GA15292@localhost>
References: <1339211455-9228-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339211455-9228-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2012 at 11:10:55AM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
> ---
>  fs/fs-writeback.c |    4 ++--
>  fs/super.c        |    2 +-
>  fs/sync.c         |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

Applied, thanks!
