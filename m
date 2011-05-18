Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab1ERWDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:03:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42073 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab1ERWDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:03:12 -0400
Date: Wed, 18 May 2011 18:03:04 -0400 (EDT)
Message-Id: <20110518.180304.1707025648201926668.davem@davemloft.net>
To: denzzzhome@yahoo.com
Cc: info@mocean-labs.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: ks8842 Fix crash on received packet when
 in PIO mode.
From: David Miller <davem@davemloft.net>
In-Reply-To: <2062.44194.qm@web120510.mail.ne1.yahoo.com>
References: <2062.44194.qm@web120510.mail.ne1.yahoo.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 May 2011 15:03:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dennis Aberilla <denzzzhome@yahoo.com>
Date: Wed, 18 May 2011 14:51:14 -0700 (PDT)

> diff --git a/drivers/net/ks8842.c b/drivers/net/ks8842.c
> index f0d8346..9069aee 100644
> --- a/drivers/net/ks8842.c
> +++ b/drivers/net/ks8842.c
> @@ -662,7 +662,7 @@ static void ks8842_rx_frame(struct net_device *netdev,
> 
>    /* check the status */
>    if ((status & RXSR_VALID) && !(status & RXSR_ERROR)) {
> -     struct sk_buff *skb = netdev_alloc_skb_ip_align(netdev, len);
> +     struct sk_buff *skb = netdev_alloc_skb_ip_align(netdev, len + 2);

Your patch has been corrupted by your email client, it has turned TAB
characters into spaces, amongst other things.  This makes your patch
unusable.

Please read Documentation/email-clients.txt, and use that information
to fix your email client, and then send the patch as a test email
to yourself and make sure that you can extract the patch and apply
it cleanly before you resend it here.

Thanks.
