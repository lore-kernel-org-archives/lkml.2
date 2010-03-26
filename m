Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0CZOwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 10:52:49 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:35000 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab0CZOws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 10:52:48 -0400
Date: Fri, 26 Mar 2010 15:52:36 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Chris Dearman <chris@mips.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix __vmalloc(), etc on MIPS for non-GPL modules
Message-ID: <20100326145236.GX4554@linux-mips.org>
References: <Pine.LNX.4.64.1003252017360.17596@hermes-2.csi.cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003252017360.17596@hermes-2.csi.cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 08:48:12PM +0000, Anton Altaparmakov wrote:

> The commit 351336929ccf222ae38ff0cb7a8dd5fd5c6236a0 which can be seen 
> here:

Which was in 2.6.26 ...

> I therefore propose that the EXPORT_SYMBOL_GPL(_page_cachable_default) is 
> changed to EXPORT_SYMBOL(_page_cachable_default) to re-instate the 
> ability for non-GPL modules to call __vmalloc(), vmap(), vm_map_ram(), 
> and such like.
> 
> Here is a patch that does this.  If you approve, please apply it.

I approve - but applying would be easier if this patch had not been
linewrapped ...

Applied to master and -stable.  Thanks!

  Ralf
