Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2FYXEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:04:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56412 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab2FYXEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:04:53 -0400
Date: Mon, 25 Jun 2012 16:04:52 -0700 (PDT)
Message-Id: <20120625.160452.987297805118709913.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ordex@autistici.org, sven@narfation.org
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120625133812.aad5804dca97e504650b7dd1@canb.auug.org.au>
References: <20120625133812.aad5804dca97e504650b7dd1@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 25 Jun 2012 13:38:12 +1000

> Today's linux-next merge of the net-next tree got a conflict in
> net/batman-adv/translation-table.c between commit 8b8e4bc0391f
> ("batman-adv: fix race condition in TT full-table replacement") from the
> net tree and commit 7d211efc5087 ("batman-adv: Prefix originator
> non-static functions with batadv_") from the net-next tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

I've also resolved this during today's net --> net-next merge.
