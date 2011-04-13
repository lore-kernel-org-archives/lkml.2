Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab1DMJO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 05:14:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757966Ab1DMJO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 05:14:56 -0400
Date: Wed, 13 Apr 2011 11:14:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: linux-next: manual merge of the trivial tree with the wireless
 tree
In-Reply-To: <20110411132844.fa651c08.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1104131114350.12035@pobox.suse.cz>
References: <20110411132844.fa651c08.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in
> drivers/net/wireless/ath/ath9k/phy.h between commit a9b6b2569cf1
> ("ath9k_hw: turn a few big macros into functions") from the wireless tree
> and commit 6eab04a87677 ("treewide: remove extra semicolons") from the
> trivial tree.
> 
> The former commit removed the code that the latter changed, so I did that.

I have reverted the chunk in question, so the conflict should be gone.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
