Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab0E0Vp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:45:57 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:55518 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab0E0Vpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:45:55 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAG+F/kurR7Ht/2dsb2JhbACeJHGnR5oZhRMEg0I
X-IronPort-AV: E=Sophos;i="4.53,313,1272844800"; 
   d="scan'208";a="203921566"
From: Roland Dreier <rdreier@cisco.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Ralph Campbell <ralph.campbell@qlogic.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
Subject: Re: linux-next: Tree for May 27 (infiniband: qib)
References: <20100527152628.b23a14c6.sfr@canb.auug.org.au>
	<20100527090503.d229dc53.randy.dunlap@oracle.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 27 May 2010 14:45:48 -0700
In-Reply-To: <20100527090503.d229dc53.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Thu, 27 May 2010 09:05:03 -0700")
Message-ID: <adaaarlvx0z.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > However, it looks like qib needs to handle DCA config in a way that
 > is similar to how it is handled in drivers/net/{myri10ge,igb,ixgbe}/
 > instead of assuming that DCA is enabled.

Looks like we're just going to rip out DCA support for now.

 > And please fix the linux-next 2010-may-25 reported qib problem:
 >   http://lkml.org/lkml/2010/5/25/321

I think that should be fixed in my for-next branch already (at least I
have a patch from Ralph called "IB/qib: Fix undefined symbol error when
CONFIG_PCI_MSI=n" in there).

 - R.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
