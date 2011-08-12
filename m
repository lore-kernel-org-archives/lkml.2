Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab1HLF4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 01:56:38 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44736 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab1HLF4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 01:56:35 -0400
Date: Thu, 11 Aug 2011 22:54:17 -0700 (PDT)
Message-Id: <20110811.225417.852034314133874910.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next] spider_net: fix compile issue introduced by driver
 move
From: David Miller <davem@davemloft.net>
In-Reply-To: <1313128038.4588.5.camel@jtkirshe-mobl>
References: <20110812144131.59de312ee6e1a9e8865c1a85@canb.auug.org.au>
	<20110812150003.1e2ba71018bea040fc7649d7@canb.auug.org.au>
	<1313128038.4588.5.camel@jtkirshe-mobl>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 11 Aug 2011 22:54:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 11 Aug 2011 22:47:17 -0700

> This is just an example of the change that would be needed to resolve
> defconfig issues.  The below patch should resolve the cxgb3/4 errors.  I
> have not made the necessary changes to resolve the mlx4 issues in this
> patch.  I can generate those as well, if need be.

The dependencies should be such that the Kconfig system will work
out whatever is needed.

If the build breaks, the dependencies are wrong and we need to fix
them.  Updating defconfigs should not be necessary to get a clean
build, it should "just work"
