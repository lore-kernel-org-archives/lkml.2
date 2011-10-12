Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1JLQQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:16:54 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:33604 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab1JLQQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:16:54 -0400
Date: Wed, 12 Oct 2011 18:16:35 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, gregkh@suse.de, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, Kai Jiang <Kai.Jiang@freescale.com>
Subject: Re: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
Message-ID: <20111012161635.GD21852@local>
References: <1318430145-19898-1-git-send-email-galak@kernel.crashing.org>
 <20111012153229.GB21852@local>
 <AD39F4F8-E9C0-4090-9AEA-644F82DD328B@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AD39F4F8-E9C0-4090-9AEA-644F82DD328B@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 11:07:09AM -0500, Kumar Gala wrote:
> 
> On Oct 12, 2011, at 10:32 AM, Hans J. Koch wrote:
> 
> > On Wed, Oct 12, 2011 at 09:35:45AM -0500, Kumar Gala wrote:
> >> From: Kai Jiang <Kai.Jiang@freescale.com>
> >> 
> >> To support >32-bit physical addresses for UIO_MEM_PHYS type we need to
> >> extend the width of 'addr' in struct uio_mem.  Numerous platforms like
> >> embedded PPC, ARM, and X86 have support for systems with larger physical
> >> address than logical.
> >> 
> >> Since 'addr' may contain a physical, logical, or virtual address the
> >> easiest solution is to just change the type to 'unsigned long long'
> >> regardless of which type is utilized.
> > 
> > No. There's phys_addr_t for that purpose, defined in include/linux/types.h.
> > Please use that.
> 
> Do we believe phys_addr_t is always greater than or equal to size need for logical & virtual addresses?

Yes.

Hans
