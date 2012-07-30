Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab2G3Nvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:51:42 -0400
Received: from verein.lst.de ([213.95.11.211]:49784 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab2G3NvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 09:51:16 -0400
Date: Mon, 30 Jul 2012 15:43:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Asias He <asias@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH V3 3/3] virtio-blk: Add bio-based IO path for virtio-blk
Message-ID: <20120730134322.GB6041@lst.de>
References: <971756309.4742543.1343457753475.JavaMail.root@redhat.com> <501610E0.8000504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501610E0.8000504@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 12:43:12PM +0800, Asias He wrote:
> I think we can add REQ_FLUSH & REQ_FUA support to bio path and that 
> deserves another patch.

Adding it is a requirement for merging the code.

