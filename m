Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2FLLdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:33:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:57318 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab2FLLdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164586250"
Date: Tue, 12 Jun 2012 19:33:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH] writeback: avoid race when update bandwidth
Message-ID: <20120612113330.GA16880@localhost>
References: <1339496803-2885-1-git-send-email-liwp.linux@gmail.com>
 <20120612112129.GA16639@localhost>
 <20120612112936.GA3026@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612112936.GA3026@kernel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 07:29:49PM +0800, Wanpeng Li wrote:
> On Tue, Jun 12, 2012 at 07:21:29PM +0800, Fengguang Wu wrote:
> >On Tue, Jun 12, 2012 at 06:26:43PM +0800, Wanpeng Li wrote:
> >> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> >
> >That email address is no longer in use?
> 
> No, :), you better use "Wanpeng Li <liwp@linux.vnet.ibm.com>" to commit
> my patch. Because next month this email address will be available again,
> and this also can help my colleagues to add my patches count this year,
> thanks a lot.

Then at least don't add liwp@linux.vnet.ibm.com in the email CC list.
It's annoying to receive error notifications.

Thanks,
Fengguang
