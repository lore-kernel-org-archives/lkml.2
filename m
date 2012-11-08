Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab2KHIsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 03:48:19 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:28229 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2KHIsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 03:48:18 -0500
X-IronPort-AV: E=Sophos;i="4.80,736,1344211200"; 
   d="scan'208";a="213851270"
Message-ID: <1352364376.12977.93.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH] add tpm_xenu.ko: Xen Virtual TPM frontend
 driver
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Matthew Fioravante <matthew.fioravante@jhuapl.edu>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mail@srajiv.net" <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Kent Yoder <key@linux.vnet.ibm.com>
Date: Thu, 8 Nov 2012 09:46:16 +0100
In-Reply-To: <20121108011006.GC21302@phenom.dumpdata.com>
References: <1352128197-1539-1-git-send-email-matthew.fioravante@jhuapl.edu>
	 <20121107144625.GA14628@ennui.austin.ibm.com>	<509AA501.1090701@jhuapl.edu>
	 <20121108011006.GC21302@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >>+typedef struct tpmif_tx_request tpmif_tx_request_t;
> > >   checkpatch warned on this new typedef - please run through checkpatch
> > >and fix up that stuff.
> > tpmif.h has a couple of typedefs which do trigger checkpatch
> > warnings. However it looks like the paradigm for xen is to have
> > these interface/io/<dev>if.h files and all of them have typedefs. I
> > think in this case the typedef should probably stay.
> > 
> > Konrad your thoughts here?
> 
> Rip them out plea

This is somewhere that Linux coding style and Xen coding style differ,
so the typedefs should be removed from the Linux copy of these
interfaces to match the Linux coding style, but they should stay in the
Xen side canonical copy though.

Ian.

