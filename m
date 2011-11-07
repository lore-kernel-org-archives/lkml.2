Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab1KGBzM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 20:55:12 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51275 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab1KGBzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 20:55:10 -0500
Date: Sun, 06 Nov 2011 20:52:59 -0500 (EST)
Message-Id: <20111106.205259.1237400984015921904.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: torvalds@linux-foundation.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregory.v.rose@intel.com,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the origin tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111107101202.96fcb76d580e5265bd99aeee@canb.auug.org.au>
References: <20111107101202.96fcb76d580e5265bd99aeee@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 06 Nov 2011 17:53:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 7 Nov 2011 10:12:02 +1100

> Starting with the origin tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
 ...
> Caused by commit 9487dc844054 ("ixgbe: Fix compiler warnings") which hid
> the declarations of ixgbe_disable_sriov() and ixgbe_check_vf_assignment()
> when CONFIG_PCI_IOV is not defined.
> 
> I have reverted that commit for today.

It should be fixed in net.git, can you please check that the build
succeeds after you pull it into -next?

If you just revert the commit in origin from -next, then you will get
conflicts with you pull the net.git tree in.
