Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab0GGWcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 18:32:12 -0400
Received: from verein.lst.de ([213.95.11.210]:56337 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab0GGWcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 18:32:10 -0400
Date: Thu, 8 Jul 2010 00:31:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>,
       Bastien ROUCARIES <roucaries.bastien@gmail.com>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Frantisek Hanzlik <franta@hanzlici.cz>, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: fs/fs-writeback oopses in kernel 2.6.33.4-95.fc13.i686.PAE
Message-ID: <20100707223157.GA27529@lst.de>
References: <4BFA730C.1010906@hanzlici.cz> <20100524230512.8cc7dfc1.akpm@linux-foundation.org> <87vdacl15j.fsf@openvz.org> <AANLkTimPwbOga_gEMajfciD8ZokBaz99c2ty9R6q_cs5@mail.gmail.com> <20100614125716.b04fcd28.akpm@linux-foundation.org> <AANLkTik3PuXz0nkOl8Fik7oqPt4xqXxQiuUo_8so0f87@mail.gmail.com> <AANLkTiniwK7gdYAze3fZ7MSi1Wm8tvYWC5LYG_5chER1@mail.gmail.com> <20100707135118.b9fbe0b2.akpm@linux-foundation.org> <20100707210209.GA24063@lst.de> <20100707141431.079a46b0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707141431.079a46b0.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 02:14:31PM -0700, Andrew Morton wrote:
> > 
> > I have no idea what oops you mean.
> 
> http://lmgtfy.com/?q=fs%2Ffs-writeback+oopses+in+kernel+2.6.33.4-95.fc13.i686.PAE

Not particularly useful.  Line numbers and function have changed
completely since .33.  Given that 2.6.33-stable is at the end of line I really
can't be bothered to go back, figure out what the hell was going on back
then and backport things.  In fact we'd probably end up backporting all
writeback changes since then anyway, as the changes to sort out the
per-sb syncs were very large and interdependent.

