Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292Ab1GFEQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 00:16:07 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:24715 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750760Ab1GFEQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 00:16:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EABrfE055LCkB/2dsb2JhbABTqA14zGkOgyaDAgSjDg
Date: Wed, 6 Jul 2011 14:16:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        eric.dumazet@gmail.com, Peter Kruse <pk@q-leap.de>,
        linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
Message-ID: <20110706041602.GX1026@dastard>
References: <272bf0cc51439a2ab31ee2f06317dd9f.squirrel@www.q-leap.de>
 <4D6648B5.1090306@q-leap.com>
 <4DA4692D.7080207@q-leap.de>
 <alpine.DEB.2.00.1104121306581.14692@router.home>
 <alpine.DEB.2.00.1104121830030.14956@chino.kir.corp.google.com>
 <4DA54D2A.3050206@q-leap.de>
 <alpine.DEB.2.00.1104131116330.19493@router.home>
 <4E09BEA1.1080501@q-leap.de>
 <alpine.DEB.2.00.1107051013500.16869@router.home>
 <20110705172043.GA15147@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705172043.GA15147@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 06:20:43PM +0100, Mel Gorman wrote:
> There are also patches that should be in 2.6.32.29 like [e52af507:
> xfs: Non-blocking inode locking in IO completion] which talks
> about deadlocks during IO completion but the kernel name is
> 2.6.32.29-ql-server-20. Does that include this patch or is it some
> other fork?
> 
> What seems more plausible is 2.6.32.29 is missing patches like this
> [081003ff: xfs: properly account for reclaimed inodes] which sounds
> like a very similar problem to what is happening here. There is a good
> chance this problem is already fixed but wasn't backported to 2.6.32.x
> unfortunately.

Fixed in 2.6.32.42.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
