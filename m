Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab1AEOvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 09:51:41 -0500
Received: from cantor.suse.de ([195.135.220.2]:36971 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab1AEOvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 09:51:39 -0500
Date: Wed, 5 Jan 2011 15:51:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the trivial tree with the net tree
In-Reply-To: <20110104142229.7aa6b99f.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1101051550240.26685@pobox.suse.cz>
References: <20110104142229.7aa6b99f.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jan 2011, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in
> drivers/net/wireless/iwlwifi/iwl-core.c between commit
> 81baf6ec9c190ae128748cf2a026bff5cb811b70 ("iwlwifi: Legacy isr only used
> by legacy devices") from the net tree and commit
> 62e45c14fb9a978dca6c7a5dc8372cc8ea2f42c8 ("wireless: comment typo fix
> diable -> disable") from the trivial tree.
> 
> The former moves the code modified by the latter to
> drivers/net/wireless/iwlwifi/iwl-legacy.c. I didn't bother refixing the
> typo there.

I will definitely be merging to Linus trivial queue later than davem will, 
so I'll be resolving this. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
