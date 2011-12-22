Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1LVU2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:28:40 -0500
Received: from verein.lst.de ([213.95.11.211]:38499 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab1LVU2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:28:38 -0500
Date: Thu, 22 Dec 2011 21:28:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan@redhat.com>
Subject: Re: [PATCH 4/6] virtio-blk: implement ->make_request
Message-ID: <20111222202836.GA1443@lst.de>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org> <1324429254-28383-5-git-send-email-minchan@kernel.org> <CAJSP0QWbkdQhXtrkO6zKrCBACRWcpD3cFz37O+uJ5s=OimSFPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QWbkdQhXtrkO6zKrCBACRWcpD3cFz37O+uJ5s=OimSFPw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 12:20:01PM +0000, Stefan Hajnoczi wrote:
> virtblk_make_request() checks that the queue is not plugged.  Do we
> need to do that here too?

biot based drivers don't have a queue that could be plugged.
