Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0D1PtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:49:05 -0400
Received: from kroah.org ([198.145.64.141]:51421 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab0D1PtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:49:01 -0400
Date: Wed, 28 Apr 2010 08:25:39 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: linux-next: manual merge of the staging-next tree with the
 pcmcia tree
Message-ID: <20100428152539.GB4483@kroah.com>
References: <20100428161153.e683cb12.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428161153.e683cb12.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 04:11:53PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging-next tree got a conflict in
> drivers/staging/netwave/netwave_cs.c between commit
> c8bf6e66c254bba7d0ea3f5d02420776dceac657 ("pcmcia: re-work
> pcmcia_request_irq()") from the pcmcia tree and commit
> 3c7475d0aaad3614f6b1db291310c577eee3fb33 ("Staging: netwave: fixed
> trailing whitespace style issue in netwave_cs.c") from the staging-next
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Fix looks fine, thanks.

greg k-h
