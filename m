Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab1I1FjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 01:39:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43304 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1I1FjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 01:39:06 -0400
Date: Wed, 28 Sep 2011 01:36:52 -0400 (EDT)
Message-Id: <20110928.013652.1712671417837562954.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ordex@autistici.org,
        lindner_marek@yahoo.de
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110928125428.70d5cf10ea59f729135d5dff@canb.auug.org.au>
References: <20110928125428.70d5cf10ea59f729135d5dff@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 27 Sep 2011 22:36:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 28 Sep 2011 12:54:28 +1000

> Today's linux-next merge of the net tree got a conflict in
> net/batman-adv/soft-interface.c between commit 8b267b312df9 ("batman-adv:
> do_bcast has to be true for broadcast packets only") from the net-current
> tree and commit 3d393e473210 ("batman-adv: implement AP-isolation on the
> sender side") from the net tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Yep, I'll do a merge soon to fix this up for good, thanks Stephen!
