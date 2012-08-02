Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2HBVlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 17:41:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:36537 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab2HBVlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 17:41:06 -0400
Message-ID: <501AF3E3.6090403@kernel.dk>
Date: Thu, 02 Aug 2012 23:40:51 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Asias He <asias@redhat.com>
CC: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Shaohua Li <shli@kernel.org>,
        Tejun Heo <tj@kernel.org>, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V5 0/4] Improve virtio-blk performance
References: <1343888757-25723-1-git-send-email-asias@redhat.com>
In-Reply-To: <1343888757-25723-1-git-send-email-asias@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 08:25 AM, Asias He wrote:
> Hi folks,
> 
> This version added REQ_FLUSH and REQ_FUA support as suggested by Christoph and
> rebased against latest linus's tree. 
> 
> Jens, could you please consider picking up the dependencies 1/4 and
> 2/4 in your tree. Thanks!

Pickedup, thanks for getting that done!


-- 
Jens Axboe

