Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab1LNSi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:38:58 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60268 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab1LNSiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:38:55 -0500
Date: Wed, 14 Dec 2011 13:36:44 -0500 (EST)
Message-Id: <20111214.133644.834042724012633409.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ordex@autistici.org
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111214132558.d9ffe5dfb2f09089cec4a21f@canb.auug.org.au>
References: <20111214132558.d9ffe5dfb2f09089cec4a21f@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 14 Dec 2011 10:36:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 14 Dec 2011 13:25:58 +1100

> Hi all,
> 
> Today's linux-next merge of the net-next tree got conflicts in
> net/batman-adv/translation-table.c between commits 03fc3070457d
> ("batman-adv: in case of roaming mark the client with TT_CLIENT_ROAM")
> and 797399b415b7 ("batman-adv: delete global entry in case of roaming")
> from the net tree and commit 48100bac89a6 ("batman-adv: create a common
> substructure for tt_global/local_entry") from the net-next tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

Thanks, we expected this, I'll take care of it next time I merge
over the net tree.
