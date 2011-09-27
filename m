Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab1I0OrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 10:47:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:38542 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab1I0OrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 10:47:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="57071930"
Subject: Re: linux-next: manual merge of the net tree with the
 wireless-current tree
From: wwguy <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
In-Reply-To: <20110927130926.GA2824@tuxdriver.com>
References: <20110927125132.002db8176a66f85286dcd027@canb.auug.org.au>
	 <20110927130926.GA2824@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 07:41:41 -0700
Message-ID: <1317134501.9384.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 06:09 -0700, John W. Linville wrote:
> On Tue, Sep 27, 2011 at 12:51:32PM +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the net tree got a conflict in
> > drivers/net/wireless/iwlwifi/iwl-scan.c between commit 6c80c39d9a69
> > ("iwlagn: fix dangling scan request") from the wireless-current tree and
> > commits 63013ae30159 ("iwlagn: priv->status moves to iwl_shared") and
> > 6ac2f839b0b2 ("iwlagn: priv->mutex moves to iwl_shared") from the net
> > tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary.
> 
> Looks good, thanks!
> 
Thanks a lot for fixing it.

Wey

