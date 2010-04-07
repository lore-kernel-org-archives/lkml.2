Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab0DGPAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:00:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55922 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735Ab0DGPAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:00:11 -0400
Date: Wed, 7 Apr 2010 10:44:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Zhu Yi <yi.zhu@intel.com>
Subject: Re: linux-next: manual merge of the wireless tree with the
	wireless-current tree
Message-ID: <20100407144434.GC3146@tuxdriver.com>
References: <20100407125828.d9f03281.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100407125828.d9f03281.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 12:58:28PM +1000, Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next merge of the wireless tree got conflicts in
> drivers/net/wireless/iwlwifi/iwl-core.c,
> drivers/net/wireless/iwlwifi/iwl-tx.c and
> drivers/net/wireless/iwlwifi/iwl-core.h between commit
> de0f60ea94e132c858caa64a44b2012e1e8580b0 ("iwlwifi: avoid Tx queue memory
> allocation in interface down") from the wireless-current tree and commit
> 74bcdb33e99f49ef5202dd2f8109945b4570edc2 ("iwlwifi: move agn only tx
> functions from iwlcore to iwlagn") from the wireless tree.
> 
> The latter moved the code modified by the former.  I couldn't see any
> easy way to fix this up, so I effectively reverted the change in the
> wireless-current tree.  Please do the merge fixup, thanks.

OK, I'll try to negotiate this today.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
