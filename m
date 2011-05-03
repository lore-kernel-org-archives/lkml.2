Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab1ECDnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 23:43:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49936
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753338Ab1ECDnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 23:43:11 -0400
Date: Mon, 02 May 2011 20:42:38 -0700 (PDT)
Message-Id: <20110502.204238.193708379.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, joe@perches.com
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110503131548.63dd3568.sfr@canb.auug.org.au>
References: <20110503131548.63dd3568.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 3 May 2011 13:15:48 +1000

> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/tg3.c between commit 6fdbab9d93e0 ("tg3: Fix failure to
> enable WoL by default when possible") from the net-current tree and
> commit 63c3a66fe6c8 ("tg3: Convert u32 flag,flg2,flg3 uses to bitmap")
> from the net tree.
> 
> Context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Do you automatically generate these emails? :-)

I CC:'d you on an email earlier about this conflict, in an effort to
let you know I anticipated it and you therefore didn't need to notify
us this time.
