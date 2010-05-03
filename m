Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab0ECWFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:05:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43506
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757055Ab0ECWFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:05:17 -0400
Date: Mon, 03 May 2010 15:05:24 -0700 (PDT)
Message-Id: <20100503.150524.250828270.davem@davemloft.net>
To: mst@redhat.com
Cc: eric.dumazet@gmail.com, ebiederm@xmission.com, johannes@sipsolutions.net,
       therbert@google.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: show stopped status in sysfs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100503212423.GA15998@redhat.com>
References: <20100503212423.GA15998@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 4 May 2010 00:24:25 +0300

> @@ -303,6 +313,7 @@ static struct device_attribute net_class_attributes[] = {
>  	__ATTR(address, S_IRUGO, show_address, NULL),
>  	__ATTR(broadcast, S_IRUGO, show_broadcast, NULL),
>  	__ATTR(carrier, S_IRUGO, show_carrier, NULL),
> +	__ATTR(carrier, S_IRUGO, show_stopped, NULL),

Besides the fact that you have to publish this as a per-queue attribute,
you're also erroneously naming it 'carrier' here.
