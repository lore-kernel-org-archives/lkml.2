Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0JSQmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:42:51 -0400
Received: from www.tglx.de ([62.245.132.106]:56003 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415Ab0JSQmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:42:50 -0400
Date: Tue, 19 Oct 2010 18:42:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Helmut Grohne <helmut@subdivi.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        pacman@kosh.dhis.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
In-Reply-To: <20101019162407.GB10148@alf.mars>
Message-ID: <alpine.LFD.2.00.1010191841430.6815@localhost6.localdomain6>
References: <20101013144044.GS30667@csn.ul.ie> <20101013175205.21187.qmail@kosh.dhis.org> <20101018113331.GB30667@csn.ul.ie> <20101018123750.ef7d6d48.akpm@linux-foundation.org> <alpine.LFD.2.00.1010182342490.6815@localhost6.localdomain6>
 <20101019162407.GB10148@alf.mars>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, Helmut Grohne wrote:

> On Mon, Oct 18, 2010 at 11:55:44PM +0200, Thomas Gleixner wrote:
> > I might be completely one off as usual, but this thing reminds me of a
> > bug I stared at yesterday night:
> 
> This problem is completely unrelated. My problem was caused by using
> binutils-gold.

Ok, thanks for the update. One thing less to worry about :)

Thanks,

	tglx
