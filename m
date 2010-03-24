Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab0CXOWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:22:23 -0400
Received: from fieldses.org ([174.143.236.118]:46270 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394Ab0CXOWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:22:21 -0400
Date: Wed, 24 Mar 2010 10:24:14 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: stable@kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: nfsd changes for 2.6.34
Message-ID: <20100324142414.GE12057@fieldses.org>
References: <20100306175212.GB22650@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100306175212.GB22650@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 12:52:12PM -0500, bfields wrote:
> Please pull the following nfsd changes from the 'nfsd' branch at:
> 
>   git://linux-nfs.org/~bfields/linux.git for-2.6.34 nfsd
> 
> This is an unusually quiet cycle for the NFS server--bugfixes, some IPv6
> progress, and one new export operation to improve sync performance.
> 
> One exception to the 'mostly quiet' statement was a regression in the
> rpc code which hit a lot of people: enormous thanks to Neil for tracking
> that down.

However, I forgot to Cc stable on all of those.  Stable people, could
you also take the following three commits?:

	f5822754ea006563e1bf0a1f43faaad49c0d8bb2 Revert "sunrpc: fix
	peername failed on closed listener"
	1b644b6e6f6160ae35ce4b52c2ca89ed3e356e18 Revert "sunrpc: move
	the close processing after do recvfrom method"
	301e99ce4a2f42a317129230fd42e6cd874c64b0 nfsd: ensure sockets
	are closed on error

Let me know if you need more information.

--b.
