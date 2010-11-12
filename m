Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0KLHqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 02:46:01 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43990 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab0KLHqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 02:46:00 -0500
Message-ID: <4CDCF0B4.9070508@kernel.dk>
Date: Fri, 12 Nov 2010 08:45:56 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "\"Xen-devel@lists.xensource.com\" li" 
	<Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Stodden <daniel.stodden@citrix.com>
Subject: Re: [GIT PULL] xen blkfront barrier updates
References: <4CDC7A3C.8070206@goop.org>
In-Reply-To: <4CDC7A3C.8070206@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-12 00:20, Jeremy Fitzhardinge wrote:
> Hi Jens,
> 
> Here's the xen-blkfront barrier changes we discussed in Boston (its
> identical to the last posted version).
> 
> The only comment was Christoph pointing out EOPNOTSUPP is not used in
> the block interface, but blkfront is just using it as a local
> placeholder and it never gets returned up to the block layer.
> 
> I still haven't sorted out what's going on with the backends; we
> definitely need either a FLUSH operation or make empty WRITE_BARRIER
> work to flush disk caches.

Thanks Jeremy, I'll pull this in.

-- 
Jens Axboe

