Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab2GLM73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:59:29 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:34413 "HELO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754790Ab2GLM71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:59:27 -0400
Message-ID: <4FFECA1F.2020005@mellanox.com>
Date: Thu, 12 Jul 2012 15:59:11 +0300
From: Hadar Hen Zion <hadarh@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Jack Morgenstein" <jackm@dev.mellanox.co.il>,
        Roland Dreier <roland@kernel.org>, <linux-rdma@vger.kernel.org>,
        Hadar Hen Zion <hadarh@mellanox.co.il>,
        "Or Gerlitz" <ogerlitz@mellanox.com>
Subject: Re: linux-next: manual merge of the net-next tree with the infiniband
 tree
References: <20120712120950.223be053857381046b7d5db6@canb.auug.org.au>
In-Reply-To: <20120712120950.223be053857381046b7d5db6@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.13.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/2012 5:09 AM, Stephen Rothwell wrote:
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
>

Thanks Stephen.

Please add:
Acked-by: Hadar Hen Zion <hadarh@mellanox.co.il>

Hadar

