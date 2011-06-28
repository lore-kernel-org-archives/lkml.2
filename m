Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab1F1Pbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:31:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:10848 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758777Ab1F1P3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:29:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,437,1304319600"; 
   d="scan'208";a="19786185"
Subject: Re: linux-next: manual merge of the net tree with the
 wireless-current tree
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
In-Reply-To: <20110628140219.1480dc7a.sfr@canb.auug.org.au>
References: <20110628140219.1480dc7a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jun 2011 07:57:14 -0700
Message-ID: <1309273034.13527.0.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 21:02 -0700, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/wireless/iwlwifi/iwl-tx.c between commits 1107a08a1a3e
> ("iwlagn: fix cmd queue unmap"), e815407d395e ("iwlagn: map command
> buffers BIDI") and 2627c002cbed ("iwlagn: use PCI_DMA_* for pci_*
> operations") from the wireless-current tree and commit 795414db8607
> ("iwlagn: don't use the PCI wrappers for DMA operation") from the net
> tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

Looks right to me. Thanks for fixing it.

Wey

