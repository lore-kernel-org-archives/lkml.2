Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab1FWDun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 23:50:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42077 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab1FWDum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 23:50:42 -0400
Date: Wed, 22 Jun 2011 20:46:33 -0700 (PDT)
Message-Id: <20110622.204633.1270632754342154052.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linville@tuxdriver.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, anderson.briglia@openbossa.org,
        anderson.lizardo@openbossa.org, bruna.moreira@openbossa.org,
        vinicius.gomes@openbossa.org, padovan@profusion.mobi,
        adobriyan@gmail.com, netdev@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the wireless tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110623130317.b3a6085e.sfr@canb.auug.org.au>
References: <20110623130317.b3a6085e.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 22 Jun 2011 20:47:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 23 Jun 2011 13:03:17 +1000

> Caused by commit d22ef0bc83c5 ("Bluetooth: Add LE SMP Cryptoolbox
> functions").  Missing include file, presumably.  This batch has been in
> the bluetooth tree since June 14, so it may have been exposed by the
> removal of linux/mm.h from netdevice.h ...

This is almost certainly the reason.
