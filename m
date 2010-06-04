Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab0FDBeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:34:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756906Ab0FDBee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:34:34 -0400
Date: Thu, 3 Jun 2010 18:34:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: mmotm 2010-06-03-16-36 uploaded
Message-Id: <20100603183410.bf61f113.akpm@linux-foundation.org>
In-Reply-To: <20100604101329D.fujita.tomonori@lab.ntt.co.jp>
References: <201006040005.o5405Afw023296@imap1.linux-foundation.org>
	<20100604101329D.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010 10:14:27 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Thu, 03 Jun 2010 16:36:51 -0700
> akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2010-06-03-16-36 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > It contains the following patches against 2.6.35-rc1:
> 
> (snip)
> 
> > ssb-add-dma_dev-to-ssb_device-structure.patch
> > b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
> > b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
> > b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
> > ssb-remove-the-ssb-dma-api.patch
> 
> Is there any reason why the above patches are still in -mm (i.e. not
> merged in the previous merge window)?

Two lines earlier:

# propagate these:

is akpm shorthand for "send these through maintainers".

I prefer to go that way if the patch isn't urgent, just to get a bit
more attention and review.  If the patch has a maintainer ack already
then I'll often merge it directly.

> I got an ACK on the first patch to ssb core from the ssb maintainer,
> ACKs on the second and third to b43legacy and b43 from the maintainer.
> 
> http://marc.info/?t=126621151900002&r=1&w=2

And none of the above patches were sent to me with acked-by:s, and
nobody sent new acked-by:s, so I didn't know this!

I guess John is the conduit for all five of the above so I'll send them
to him now and he might decide to squeak them into 2.6.35.

But before I do that, please send me an email telling me who acked each
patch and I'll update that info.

Thanks.
