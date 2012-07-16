Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab2GPIaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:30:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50680 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab2GPI37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:29:59 -0400
From: Jack Morgenstein <jackm@dev.mellanox.co.il>
Organization: Mellanox
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the net-next tree with the infiniband tree
Date: Mon, 16 Jul 2012 11:33:16 +0300
User-Agent: KMail/1.9.1
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org,
        Hadar Hen Zion <hadarh@mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>
References: <20120712120950.223be053857381046b7d5db6@canb.auug.org.au>
In-Reply-To: <20120712120950.223be053857381046b7d5db6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201207161133.16886.jackm@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2012 05:09, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/ethernet/mellanox/mlx4/main.c between commit 6634961c14d3
> ("mlx4: Put physical GID and P_Key table sizes in mlx4_phys_caps struct
> and paravirtualize them") from the infiniband tree and commit
> 0ff1fb654bec ("{NET, IB}/mlx4: Add device managed flow steering firmware
> API") from the net-next tree.
> 
> Just context changes (I think).  I have fixed it up (see below) and can
> carry the fix as necessary.

Thanks, Stephen!

Ack for IB side.

-Jack
