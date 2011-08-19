Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1HSPAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:00:19 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40641 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1HSPAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:00:17 -0400
Date: Thu, 18 Aug 2011 18:03:35 -0700
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Pirko <jpirko@redhat.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the wireless tree with the net tree
Message-ID: <20110819010334.GC2487@tuxdriver.com>
References: <20110819105946.a46aa8a997f466d8a2e7f2f3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819105946.a46aa8a997f466d8a2e7f2f3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 10:59:46AM +1000, Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next merge of the wireless tree got a conflict in
> drivers/staging/ath6kl/os/linux/ar6000_drv.c between commit afc4b13df143
> ("net: remove use of ndo_set_multicast_list in drivers") from the net
> tree and commit af2bf4b4ee58 ("staging: remove ath6kl") from the wireless
> tree.
> 
> I just removed the file.

Cool, thanks.  I imagine that any more "bombing runs" that touch
ath6kl in staging will be able to resolved in the same fashion.

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
