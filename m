Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab2KHNcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:32:12 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23423 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2KHNcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:32:10 -0500
Date: Thu, 8 Nov 2012 08:31:45 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Matthew Fioravante <matthew.fioravante@jhuapl.edu>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mail@srajiv.net" <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] [PATCH] add tpm_xenu.ko: Xen Virtual TPM frontend
 driver
Message-ID: <20121108133145.GC3081@phenom.dumpdata.com>
References: <1352128197-1539-1-git-send-email-matthew.fioravante@jhuapl.edu>
 <20121107144625.GA14628@ennui.austin.ibm.com>
 <509AA501.1090701@jhuapl.edu>
 <20121108011006.GC21302@phenom.dumpdata.com>
 <1352364376.12977.93.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352364376.12977.93.camel@hastur.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 09:46:16AM +0100, Ian Campbell wrote:
> > > >>+typedef struct tpmif_tx_request tpmif_tx_request_t;
> > > >   checkpatch warned on this new typedef - please run through checkpatch
> > > >and fix up that stuff.
> > > tpmif.h has a couple of typedefs which do trigger checkpatch
> > > warnings. However it looks like the paradigm for xen is to have
> > > these interface/io/<dev>if.h files and all of them have typedefs. I
> > > think in this case the typedef should probably stay.
> > > 
> > > Konrad your thoughts here?
> > 
> > Rip them out plea
> 
> This is somewhere that Linux coding style and Xen coding style differ,
> so the typedefs should be removed from the Linux copy of these
> interfaces to match the Linux coding style, but they should stay in the
> Xen side canonical copy though.

Yes. Sorry for not making that clear.
> 
> Ian.
