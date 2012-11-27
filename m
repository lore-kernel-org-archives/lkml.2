Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab2K0Gqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:46:33 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:59184 "HELO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756732Ab2K0Gq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:46:29 -0500
Message-ID: <50B460FA.1080603@mellanox.com>
Date: Tue, 27 Nov 2012 08:43:06 +0200
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>, <linux-rdma@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Amir Vadai <amirv@mellanox.com>
Subject: Re: linux-next: manual merge of the net-next tree with the infiniband
 tree
References: <20121127114751.6961da02245ed6851190aca2@canb.auug.org.au>
In-Reply-To: <20121127114751.6961da02245ed6851190aca2@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.13.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/11/2012 02:47, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/ethernet/mellanox/mlx4/en_rx.c between commit 08ff32352d6f
> ("mlx4: 64-byte CQE/EQE support") from the infiniband tree and commit
> f1d29a3fa68b ("mlx4_en: Remove remnants of LRO support") from the
> net-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>

Acked-by: Or Geritz <ogerlitz@mellanox.com>
