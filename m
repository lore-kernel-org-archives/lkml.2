Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab1ATDX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 22:23:28 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:65258 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab1ATDX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 22:23:27 -0500
X-Greylist: delayed 1434 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jan 2011 22:23:27 EST
To: James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, maximlevitsky@gmail.com, axboe@kernel.dk,
        oakad@yahoo.com, tj@kernel.org, fujita.tomonori@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org
Subject: Re: + scatterlist-new-helper-functions-update.patch added to -mm
 tree
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1295473258.10978.31.camel@mulgrave.site>
References: <1295470481.10978.3.camel@mulgrave.site>
	<20110119130648.968bb59f.akpm@linux-foundation.org>
	<1295473258.10978.31.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110120113400M.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 20 Jan 2011 11:34:00 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jan 2011 15:40:58 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2011-01-19 at 13:06 -0800, Andrew Morton wrote:
> > On Wed, 19 Jan 2011 14:54:41 -0600
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > On Wed, 2011-01-19 at 11:37 -0800, akpm@linux-foundation.org wrote:
> > > > The patch titled
> > > >      scatterlist-new-helper-functions-update
> > > > has been added to the -mm tree.  Its filename is
> > > >      scatterlist-new-helper-functions-update.patch

(snip)

> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > 
> > While developing memstick driver for legacy memsticks I found the need in
> > few helpers that I think are ok to have in common sg library

Where is the driver available? I'm interested in how you try to use
these functions. For example, why do you want to calucalate the total
lenght and the number of entries of a sg instead of storing the
information that the block layer (or other subsystems that your driver
uses) gives?
