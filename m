Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab1HDKQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:16:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60299 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab1HDKQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:16:41 -0400
Date: Thu, 04 Aug 2011 03:13:56 -0700 (PDT)
Message-Id: <20110804.031356.626082809394107925.davem@davemloft.net>
To: tj@kernel.org
Cc: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@redhat.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH 16/23] sparc: Use HAVE_MEMBLOCK_NODE_MAP
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110804095218.GB2731@htj.dyndns.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
	<1311694534-5161-17-git-send-email-tj@kernel.org>
	<20110804095218.GB2731@htj.dyndns.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 04 Aug 2011 03:13:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu, 4 Aug 2011 11:52:18 +0200

> On Tue, Jul 26, 2011 at 05:35:27PM +0200, Tejun Heo wrote:
>> sparc doesn't access early_node_map[] directly and enabling
>> HAVE_MEMBLOCK_NODE_MAP is trivial - replacing add_active_range() calls
>> with memblock_set_node() and selecting HAVE_MEMBLOCK_NODE_MAP is
>> enough.
>> 
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: sparclinux@vger.kernel.org
> 
> David just confirmed this worked fine on sparc and was okay with this
> going through tip.

Yep:

Acked-by: David S. Miller <davem@davemloft.net>
