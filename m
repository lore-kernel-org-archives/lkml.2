Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2CZUJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:09:23 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34334 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab2CZUJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:09:22 -0400
Date: Mon, 26 Mar 2012 13:08:50 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: lib/crc32: new Kconfig prompt without help text
Message-ID: <20120326200850.GA14821@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20120325113525.778eb2cd@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120325113525.778eb2cd@stein>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032620-5112-0000-0000-000006848DE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2012 at 11:35:25AM +0200, Stefan Richter wrote:
> Hi Darrick,
> 
> the new prompt "CRC32 implementation" doesn't have an own help text, only
> its subsequent options have.  This is fine with a configurator like
> xconfig.  But "make oldconfig" only shows help text at the choice itself,
> not at the options:
> 
> $ make oldconfig
> [...]
> > CRC32/CRC32c functions (CRC32) [Y/?] y
> >   CRC32 perform self test on init (CRC32_SELFTEST) [N/y/?] (NEW) 
> >   CRC32 implementation
> >   > 1. Slice by 8 bytes (CRC32_SLICEBY8) (NEW)
> >     2. Slice by 4 bytes (CRC32_SLICEBY4) (NEW)
> >     3. Sarwate's Algorithm (one byte at a time) (CRC32_SARWATE) (NEW)
> >     4. Classic Algorithm (one bit at a time) (CRC32_BIT) (NEW)
> >   choice[1-4]: ?
> > 
> > There is no help available for this option.

Hmmm, I guess there should be help available for this option.  Will send one
soon.

--D
> 
> -- 
> Stefan Richter
> -=====-===-- --== ==--=
> http://arcgraph.de/sr/
> 

