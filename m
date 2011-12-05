Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab1LEPAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 10:00:18 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39312 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab1LEPAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:00:17 -0500
Date: Mon, 5 Dec 2011 09:53:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: linux-next: manual merge of the net-next tree with the  tree
Message-ID: <20111205145320.GA2531@tuxdriver.com>
References: <20111205123428.47213da24624d85aa84711f3@canb.auug.org.au>
 <20111205153416.e1dd01e5368ce7c016d99a59@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205153416.e1dd01e5368ce7c016d99a59@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 03:34:16PM +1100, Stephen Rothwell wrote:
> On Mon, 5 Dec 2011 12:34:28 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next merge of the net-next tree got a conflict in
> > drivers/net/wireless/iwlwifi/iwl-agn.c between commits from the
> 
> wireless (sorry)
> 
> > tree and commit 7335613ae27a ("iwlwifi: move all mac80211 related
> > functions to one place") from the net-next tree.
> > 
> > I just used the net-next version (which may require some fixes).

Yeah, I'll try to get that straightened-out over the next day or two.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
