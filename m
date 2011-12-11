Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1LKXeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 18:34:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab1LKXd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 18:33:59 -0500
Date: Mon, 12 Dec 2011 00:33:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: manual merge of the trivial tree with the wireless-next
 tree
In-Reply-To: <20111205133757.2b6cd1675543c7da26f663a5@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1112120033380.21970@pobox.suse.cz>
References: <20111205133757.2b6cd1675543c7da26f663a5@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> net/mac80211/work.c between commit e76aadc57228 ("mac80211: revert
> on-channel work optimisations") from the wireless-next tree and commit
> 42b2aa86c667 ("treewide: Fix typos in various parts of the kernel, and
> fix some comments") from the trivial tree.
> 
> The former removed the comment that was fixed in the latter, so I did
> that.

I have now dropped the conflicting hunk, thanks for reporting, Stephen.

-- 
Jiri Kosina
SUSE Labs
