Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab0KKE1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 23:27:47 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:15862 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932340Ab0KKE1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 23:27:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOX/2kx5LcZK/2dsb2JhbACiPHK/RoVKBA
Date: Thu, 11 Nov 2010 15:27:39 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101111042739.GA6228@amd>
References: <20101109124610.GB11477@amd>
 <87lj52pokp.fsf@basil.nowhere.org>
 <20101109213619.GA3246@amd>
 <20101110144721.GC7205@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110144721.GC7205@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 03:47:21PM +0100, Andi Kleen wrote:
> > It is in the inode_init_once pile, so yes it has to be returned
> > to the allocator initialized.
> 
> The kmem_cache_create()s in the file systems don't pass constructors
> today. So I don't see how this could work reliably.

They do, grep filesystems for inode_init_once


