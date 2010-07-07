Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0GGVDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:03:16 -0400
Received: from verein.lst.de ([213.95.11.210]:55279 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab0GGVDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:03:15 -0400
Date: Wed, 7 Jul 2010 23:02:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bastien ROUCARIES <roucaries.bastien@gmail.com>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Frantisek Hanzlik <franta@hanzlici.cz>, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>, Kyle McMartin <kyle@mcmartin.ca>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: fs/fs-writeback oopses in kernel 2.6.33.4-95.fc13.i686.PAE
Message-ID: <20100707210209.GA24063@lst.de>
References: <4BFA730C.1010906@hanzlici.cz> <20100524230512.8cc7dfc1.akpm@linux-foundation.org> <87vdacl15j.fsf@openvz.org> <AANLkTimPwbOga_gEMajfciD8ZokBaz99c2ty9R6q_cs5@mail.gmail.com> <20100614125716.b04fcd28.akpm@linux-foundation.org> <AANLkTik3PuXz0nkOl8Fik7oqPt4xqXxQiuUo_8so0f87@mail.gmail.com> <AANLkTiniwK7gdYAze3fZ7MSi1Wm8tvYWC5LYG_5chER1@mail.gmail.com> <20100707135118.b9fbe0b2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707135118.b9fbe0b2.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 01:51:18PM -0700, Andrew Morton wrote:
> There have been various dramas in the writeback code recently. 
> Christoph has been working on it.
> 
> Christoph, is this oops known about, and are those patches expected to
> fix it?

I have no idea what oops you mean.  But the writeback code is very
different now compared to 2.6.33, and with the latest fixes in Jens'
tree there are no known issues left. (know to me anyway)

