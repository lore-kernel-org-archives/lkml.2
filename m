Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744Ab0GBOQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 10:16:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45865 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716Ab0GBOQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 10:16:01 -0400
Date: Fri, 2 Jul 2010 10:15:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alex Elder <aelder@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
       xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] xfs: minimize DMAPI footprint
Message-ID: <20100702141559.GA6259@infradead.org>
References: <1277762653.2040.554.camel@doink>
 <20100629075734.GA31118@infradead.org>
 <20100630002043.GB24712@dastard>
 <1278079547.1876.82.camel@doink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278079547.1876.82.camel@doink>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 09:05:47AM -0500, Alex Elder wrote:
> Here is what I plan to do:
> - Accept Christoph's "drop dmapi hooks" patch into the
>   XFS master branch.  Once that's in, there's a huge
>   cascade of subsequent work that need to be pulled in
>   and I'll get those out there also.
> - Work on creating a complete and working dmapi branch.
>   Once we've got a fairly well-integrated whole, I will
>   publish that branch on the XFS git tree.  We will plan
>   to maintain that in parallel with the XFS master branch,
>   re-basing it on the master branch periodically.
> - I'll make an announcement on the list about the 
>   availability of the new branch.

Thanks.  I think I still have a few old patches for dmapi code from a
few years ago that I can repost to simplify that code.
