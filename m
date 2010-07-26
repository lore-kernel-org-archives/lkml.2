Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab0GZEcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 00:32:06 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59013 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab0GZEcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 00:32:04 -0400
Date: Mon, 26 Jul 2010 05:31:42 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: unable to fetch mips tree
Message-ID: <20100726043142.GA4732@linux-mips.org>
References: <20100726103832.34ec95dd.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726103832.34ec95dd.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 10:38:32AM +1000, Stephen Rothwell wrote:

> Fetching the mips tree today, I received this error:
> 
> git.linux-mips.org[0: 78.24.191.183]: errno=Connection refused
> fatal: unable to connect a socket (Connection refused)

Thanks for letting me know; I solved the problem.

> Just a heads up.  I will use the mips tree that I fetched over the
> weekend (top commit 18931956adefdb896025a3a03a9939571c84a2cf "MIPS:
> Octeon: HOTPLUG_CPU fixes").

This is still current.

  Ralf
