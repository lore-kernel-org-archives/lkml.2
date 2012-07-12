Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161010Ab2GLM6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:58:08 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:46093 "HELO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754434Ab2GLM6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:58:04 -0400
Message-ID: <4FFEC9CE.3000306@mellanox.com>
Date: Thu, 12 Jul 2012 15:57:50 +0300
From: Hadar Hen Zion <hadarh@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hadar Hen Zion <hadarh@mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Roland Dreier <roland@kernel.org>, <linux-rdma@vger.kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the infiniband
 tree
References: <20120712121307.a482863a98848e3813690ef2@canb.auug.org.au>
In-Reply-To: <20120712121307.a482863a98848e3813690ef2@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.13.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/2012 5:13 AM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in
> include/linux/mlx4/device.h between commit 396f2feb05d7 ("mlx4_core:
> Implement mechanism for reserved Q_Keys") from the infiniband tree and
> commit 0ff1fb654bec ("{NET, IB}/mlx4: Add device managed flow steering
> firmware API") from the net-next tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix
> as necessary.
>

Thanks Stephen.

Please add:
Acked-by: Hadar Hen Zion <hadarh@mellanox.co.il>

Hadar

