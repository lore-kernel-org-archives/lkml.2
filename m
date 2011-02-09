Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab1BIBGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 20:06:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40832
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036Ab1BIBGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:06:12 -0500
Date: Tue, 08 Feb 2011 17:06:47 -0800 (PST)
Message-Id: <20110208.170647.116377212.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
        jeffrey.t.kirsher@intel.com, bruce.w.allan@intel.com
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110209115609.79932942.sfr@canb.auug.org.au>
References: <20110209115609.79932942.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 9 Feb 2011 11:56:09 +1100

> Today's linux-next merge of the net tree got a conflict in
> drivers/net/e1000e/netdev.c between commit
> 463342741222c79469303cdab8ce99c8bc2d80e8 ("e1000e: tx_timeout should not
> increment for non-hang events") from the net-current tree and commit
> 90da06692532541a38f9857972e1fd6b1cdfb45a ("e1000e: reduce scope of some
> variables, remove unnecessary ones") from the net tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

I'll do a merge to clear this up, thanks Stephen.
