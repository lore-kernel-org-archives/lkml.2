Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0C3NPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 09:15:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35172 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab0C3NPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 09:15:12 -0400
Date: Tue, 30 Mar 2010 09:12:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Shanyu Zhao <shanyu.zhao@intel.com>, Zhu Yi <yi.zhu@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Johannes Berg <johannes.berg@intel.com>
Subject: Re: linux-next: manual merge of the net tree with the
	wireless-current tree
Message-ID: <20100330131220.GA13120@tuxdriver.com>
References: <20100330133745.27295ee0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330133745.27295ee0.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 01:37:45PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/wireless/iwlwifi/iwl-agn.c between commit
> d4dca4e53fde2953d74198a2c445db1d36ed9fd2 ("iwlwifi: clear unattended
> interrupts in tasklet") from the wireless-current tree and commit
> a4c8b2a692601de0a7bcb032b69f806050944dff ("iwlwifi: move ICT data to agn
> part of union") from the net tree.
> 
> I fixed it up (see below) and can carry the fix for a while.

Yes, that looks correct to me -- at least, that's what I did in
wireless-testing. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
