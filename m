Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2AWK3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 05:29:10 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50228 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057Ab2AWK3I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 05:29:08 -0500
MIME-Version: 1.0
In-Reply-To: <CANX6Da=Y5zJ4xi8=gLZZ8tUnnqxNCpvC0yBGruObWzYHrucLLg@mail.gmail.com>
References: <1327179463-13980-1-git-send-email-netdev@pradeepdalvi.com>
	<CANX6Da=Y5zJ4xi8=gLZZ8tUnnqxNCpvC0yBGruObWzYHrucLLg@mail.gmail.com>
Date: Mon, 23 Jan 2012 15:59:06 +0530
Message-ID: <CA+Dx6HZci3qni-FUQBw62hZsS0FMomNdQysZGsmNr_fceN4CQg@mail.gmail.com>
Subject: Re: [PATCH] netdev/ethernet: dev_alloc_skb to netdev_alloc_skb
From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
To: Viral Mehta <viral.vkm@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 2:10 PM, Viral Mehta <viral.vkm@gmail.com> wrote:
> On Sun, Jan 22, 2012 at 2:27 AM, Pradeep A. Dalvi
> <netdev@pradeepdalvi.com> wrote:
>> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>>
>> Signed-off-by: Pradeep A. Dalvi <netdev@pradeepdalvi.com>
>
> and these too ??
>
> vmehta@viralmehta:~/linux-3.2/drivers/infiniband/hw$ grep dev_alloc_skb -r .
> ./ipath/ipath_driver.c: skb = __dev_alloc_skb(len, gfp_mask);
> ./nes/nes_cm.c: skb = dev_alloc_skb(MAX_CM_BUFFER);
> ./nes/nes_cm.c:         skb = dev_alloc_skb(MAX_CM_BUFFER);
> ./nes/nes_cm.c:         skb = dev_alloc_skb(MAX_CM_BUFFER);
> ./nes/nes_cm.c:         skb = dev_alloc_skb(MAX_CM_BUFFER);
> ./nes/nes_cm.c:         skb = dev_alloc_skb(MAX_CM_BUFFER);
> ./nes/nes_hw.c:         skb = dev_alloc_skb(nesvnic->max_frame_size);
> ./nes/nes_hw.c:         skb = dev_alloc_skb(nesvnic->max_frame_size);
> ./nes/nes_mgt.c:                skb = dev_alloc_skb(mgtvnic->nesvnic->max_frame_size);
> ./nes/nes_mgt.c:                        skb = dev_alloc_skb(nesvnic->max_frame_size);
> ./amso1100/c2.c:        skb = dev_alloc_skb(c2_port->rx_buf_size);
> vmehta@viralmehta:~/linux-3.2/drivers/infiniband/hw$

This patch is for drivers/net/ethernet directory & haven't touched
infiniband directory.
