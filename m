Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab0JHGLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 02:11:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40736 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0JHGLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 02:11:11 -0400
Date: Fri, 8 Oct 2010 08:11:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andi Kleen <andi@firstfloor.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the hwpoison tree with Linus' tree
Message-ID: <20101008061106.GB13352@basil.fritz.box>
References: <20101008144037.f487b6d7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008144037.f487b6d7.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 02:40:37PM +1100, Stephen Rothwell wrote:
> Hi Andi,
> 
> Today's linux-next merge of the hwpoison tree got a conflict in
> mm/memory-failure.c between commit
> 0d9ee6a2d4a6e92c49e6fa9469e5731d21ee203e ("HWPOISON: Report correct
> address granuality for AO huge page errors") from Linus' tree and commit
> 3c5ca5455796841ac3cd706a91ba8dada908c375 ("HWPOISON: Report correct
> address granuality for AO huge page errors") from the hwpoison tree.
> 
> Slightly different versions of the same patch.  I used the version from

Yes I did a rebase here.

> Linus' tree (since it was committed later).  The conflict looked like this:

I will rebase the tree. Thanks for catching.


-Andi
