Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423488Ab2LFM5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 07:57:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab2LFM5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 07:57:07 -0500
Date: Thu, 6 Dec 2012 15:00:04 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Asias He <asias@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost-blk: Add vhost-blk support v6
Message-ID: <20121206130004.GA21312@redhat.com>
References: <1354412033-32372-1-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354412033-32372-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2012 at 09:33:53AM +0800, Asias He wrote:
> diff --git a/drivers/vhost/Kconfig.blk b/drivers/vhost/Kconfig.blk
> new file mode 100644
> index 0000000..ff8ab76
> --- /dev/null
> +++ b/drivers/vhost/Kconfig.blk
> @@ -0,0 +1,10 @@
> +config VHOST_BLK
> +	tristate "Host kernel accelerator for virtio blk (EXPERIMENTAL)"
> +	depends on BLOCK &&  EXPERIMENTAL && m


should depend on eventfd as well.
