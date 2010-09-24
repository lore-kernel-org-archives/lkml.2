Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0IXMJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:09:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716Ab0IXMJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:09:50 -0400
Date: Fri, 24 Sep 2010 14:09:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Weber <weber@corscience.de>
Subject: Re: linux-next: manual merge of the trivial tree with the net tree
In-Reply-To: <20100924121924.8fb5dfb5.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1009241409320.26813@pobox.suse.cz>
References: <20100924121924.8fb5dfb5.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> drivers/net/bnx2x/bnx2x_link.c between commit
> 62b29a5dd0930e0c956b6740f32d5b3bbaf20136 ("bnx2x: Adjust alignment of
> split PHY functions") from the net tree and commit
> 0b1974de66f9ed44f1423449628f4926bf95b854 ("Fix typo: configuation =>
> configuration") from the trivial tree.
> 
> The former removes the text updated by the latter, so I used the former.
> 
> Jiri, you might like to drop that hunk from the patch in your tree.

Done now, thanks for reporting.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
