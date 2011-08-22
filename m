Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1HVGf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 02:35:27 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:38340 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1HVGfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 02:35:25 -0400
Date: Mon, 22 Aug 2011 08:34:59 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, vgoyal@redhat.com,
        ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch 0/2] kdump: Common code changes for s390 kdump support
Message-ID: <20110822083459.2cc52fc8@mschwide>
In-Reply-To: <20110819150353.bf58c7e0.akpm@linux-foundation.org>
References: <20110819141857.052232873@linux.vnet.ibm.com>
	<20110819150353.bf58c7e0.akpm@linux-foundation.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011 15:03:53 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 19 Aug 2011 16:18:57 +0200
> Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:
> 
> > I had a long discussion with Vivek Goyal on the s390 kdump support (thanks
> > Vivek for all the time!). As a result of this, here are two common code
> > patches that are required for the s390 port. Could you please integrate them
> > upstream in the next merge window? The s390 specific part will be integrated
> > by our s390 maintainer Martin Schwidefsky.
> 
> The patches look OK to me.  I suggest that they be carried in Martin's
> tree, alongside the s390 kdump support.  That will somewhat simplify
> things during the merge window, and will greatly simplify getting the
> entire feature into linux-next.
> 
> You can put my acked-by's on them if you like.
> 
> > I will be on vacation for the next two weeks. Therefore if you have comments
> > or questions, please contact also Martin Schwidefsky and Heiko Carstens.
> 
> I'll put the patches into my tree (and hence linux-next) now, because I
> need the typing practice ;) I'll drop them again if/when they turn up
> in linux-next's s390 tree.

Ok, sounds reasonable to me. I'll take them via the s390 tree and add
you acked-by. Thanks Andrew. 


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

