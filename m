Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab0DALpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:45:12 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57221 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab0DALpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:45:07 -0400
Date: Thu, 1 Apr 2010 07:43:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: linux-next: manual merge of the wireless tree with the
	wireless-current tree
Message-ID: <20100401114355.GA6897@tuxdriver.com>
References: <20100401125944.54adc73c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401125944.54adc73c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 12:59:44PM +1100, Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next merge of the wireless tree got a conflict in
> drivers/net/wireless/iwlwifi/iwl-4965.c between commit
> be6b38bcb175613f239e0b302607db346472c6b6 ("iwlwifi: counting number of
> tfds can be free for 4965") from the wireless-current tree and commit
> 74bcdb33e99f49ef5202dd2f8109945b4570edc2 ("iwlwifi: move agn only tx
> functions from iwlcore to iwlagn") from the wireless tree.
> 
> I fixed it up (see below) and can carry the fix for a while.

Yes, that looks correct to me.

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
