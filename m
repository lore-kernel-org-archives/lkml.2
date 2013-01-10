Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab3AJLzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:55:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab3AJLzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:55:15 -0500
Date: Thu, 10 Jan 2013 12:55:03 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tun: avoid owner checks on IFF_ATTACH_QUEUE
Message-ID: <20130110115503.GD30885@stefanha-thinkpad.redhat.com>
References: <20130110113108.GF13451@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130110113108.GF13451@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 01:31:08PM +0200, Michael S. Tsirkin wrote:
> At the moment, we check owner when we enable queue in tun.
> This seems redundant and will break some valid uses
> where fd is passed around: I think TUNSETOWNER is there
> to prevent others from attaching to a persistent device not
> owned by them. Here the fd is already attached,
> enabling/disabling queue is more like read/write.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> ---
> 
> Note: this is unrelated to Stefan's bugfix.

This should go into 3.8-rc.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
