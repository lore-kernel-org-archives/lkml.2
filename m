Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab0KLUZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 15:25:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47696
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932661Ab0KLUZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 15:25:28 -0500
Date: Fri, 12 Nov 2010 12:25:53 -0800 (PST)
Message-Id: <20101112.122553.246519981.davem@davemloft.net>
To: jasowang@redhat.com
Cc: rusty@rustcorp.com.au, markmc@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, mst@redhat.com
Subject: Re: [V2 PATCH] virtio-net: init link state correctly
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101105025008.3277.87697.stgit@dhcp-91-158.nay.redhat.com>
References: <20101105025008.3277.87697.stgit@dhcp-91-158.nay.redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 05 Nov 2010 10:50:08 +0800

> For device that supports VIRTIO_NET_F_STATUS, there's no need to
> assume the link is up and we need to call nerif_carrier_off() before
> querying device status, otherwise we may get wrong operstate after
> diver was loaded because the link watch event was not fired as
> expected.
> 
> For device that does not support VIRITO_NET_F_STATUS, we could not get
> its status through virtnet_update_status() and what we can only do is
> always assuming the link is up.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I've applied Rusty's submission of this patch which has Michael T.'s
ACK, etc.
