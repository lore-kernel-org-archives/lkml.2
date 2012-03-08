Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab2CHG5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:57:43 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:58204 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2CHG5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:57:37 -0500
Date: Wed, 07 Mar 2012 22:53:01 -0800 (PST)
Message-Id: <20120307.225301.360050313988337392.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        JBottomley@parallels.com, netdev@vger.kernel.org, alan@linux.intel.com,
        brking@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] powerpc: remove the legacy iSeries platform
 specific drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
References: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 07 Mar 2012 22:53:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 8 Mar 2012 15:28:53 +1100

> It would probably be easiest if all these patches were merged via the
> powerpc tree to eliminate any dependencies between them.  Their impact on
> generic code is very small.

No objections.
