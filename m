Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0KJOr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:47:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43912 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab0KJOr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:47:26 -0500
Date: Wed, 10 Nov 2010 15:47:21 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Andi Kleen <andi@firstfloor.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101110144721.GC7205@basil.fritz.box>
References: <20101109124610.GB11477@amd>
 <87lj52pokp.fsf@basil.nowhere.org>
 <20101109213619.GA3246@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109213619.GA3246@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is in the inode_init_once pile, so yes it has to be returned
> to the allocator initialized.

The kmem_cache_create()s in the file systems don't pass constructors
today. So I don't see how this could work reliably.

-Andi
