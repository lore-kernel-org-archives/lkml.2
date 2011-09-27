Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1I0NPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:15:43 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51646 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab1I0NPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:15:42 -0400
Date: Tue, 27 Sep 2011 09:09:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: linux-next: manual merge of the net tree with the
 wireless-current tree
Message-ID: <20110927130926.GA2824@tuxdriver.com>
References: <20110927125132.002db8176a66f85286dcd027@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927125132.002db8176a66f85286dcd027@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 12:51:32PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/wireless/iwlwifi/iwl-scan.c between commit 6c80c39d9a69
> ("iwlagn: fix dangling scan request") from the wireless-current tree and
> commits 63013ae30159 ("iwlagn: priv->status moves to iwl_shared") and
> 6ac2f839b0b2 ("iwlagn: priv->mutex moves to iwl_shared") from the net
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Looks good, thanks!

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
