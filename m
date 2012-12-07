Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab2LGHDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 02:03:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab2LGHD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 02:03:28 -0500
Message-ID: <50C19534.2000705@redhat.com>
Date: Fri, 07 Dec 2012 15:05:24 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost-blk: Add vhost-blk support v6
References: <1354412033-32372-1-git-send-email-asias@redhat.com> <20121206130004.GA21312@redhat.com>
In-Reply-To: <20121206130004.GA21312@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 09:00 PM, Michael S. Tsirkin wrote:
> On Sun, Dec 02, 2012 at 09:33:53AM +0800, Asias He wrote:
>> diff --git a/drivers/vhost/Kconfig.blk b/drivers/vhost/Kconfig.blk
>> new file mode 100644
>> index 0000000..ff8ab76
>> --- /dev/null
>> +++ b/drivers/vhost/Kconfig.blk
>> @@ -0,0 +1,10 @@
>> +config VHOST_BLK
>> +	tristate "Host kernel accelerator for virtio blk (EXPERIMENTAL)"
>> +	depends on BLOCK &&  EXPERIMENTAL && m
> 
> 
> should depend on eventfd as well.

Okay, added.

-- 
Asias
