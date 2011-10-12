Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1JLQTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:19:49 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:34077 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab1JLQTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:19:48 -0400
Date: Wed, 12 Oct 2011 18:19:31 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Kumar Gala <galak@kernel.crashing.org>, gregkh@suse.de,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Kai Jiang <Kai.Jiang@freescale.com>
Subject: Re: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
Message-ID: <20111012161931.GE21852@local>
References: <1318430145-19898-1-git-send-email-galak@kernel.crashing.org>
 <20111012153229.GB21852@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012153229.GB21852@local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 05:32:29PM +0200, Hans J. Koch wrote:
> On Wed, Oct 12, 2011 at 09:35:45AM -0500, Kumar Gala wrote:
> > From: Kai Jiang <Kai.Jiang@freescale.com>
> > 
> > To support >32-bit physical addresses for UIO_MEM_PHYS type we need to
> > extend the width of 'addr' in struct uio_mem.  Numerous platforms like
> > embedded PPC, ARM, and X86 have support for systems with larger physical
> > address than logical.
> > 
> > Since 'addr' may contain a physical, logical, or virtual address the
> > easiest solution is to just change the type to 'unsigned long long'
> > regardless of which type is utilized.
> 
> No. There's phys_addr_t for that purpose, defined in include/linux/types.h.
> Please use that.

I forgot: If you resend this, please update the documentation as well.
(Documentation/DocBook/uio-howto.tmpl)

Thanks,
Hans

