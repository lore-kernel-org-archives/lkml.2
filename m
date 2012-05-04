Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab2EDEmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 00:42:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:60670 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2EDEmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 00:42:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161773759"
Subject: Re: linux-next: manual merge of the net-next tree with the
 wireless tree
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>, alexander.duyck@gmail.com,
        alexander.h.duyck@intel.com, jeffrey.t.kirsher@intel.com,
        linux-wireless@vger.kernel.org
In-Reply-To: <20120504132138.d0142070434e502dfcb8a980@canb.auug.org.au>
References: <20120504132138.d0142070434e502dfcb8a980@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 May 2012 21:35:30 -0700
Message-ID: <1336106130.11261.5.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 13:21 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got conflicts in
> drivers/net/wireless/iwlwifi/iwl-trans.h,
> drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c, and
> drivers/net/wireless/iwlwifi/iwl-agn-rx.c between commit ed90542b0ce5
> ("iwlwifi: fix skb truesize underestimation") from the wireless tree and
> various commits from the net-next tree.
> 
> This was anticipated and I have applied the fix supplied by John (see
> below just to check).  Thanks to John for this!

Thanks everyone to help address this, it is my miss to cause all these trouble

Wey


