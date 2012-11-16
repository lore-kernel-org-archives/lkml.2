Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2KPPrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:47:04 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43729 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2KPPrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:47:02 -0500
Date: Fri, 16 Nov 2012 10:44:51 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
Cc: "key@linux.vnet.ibm.com" <key@linux.vnet.ibm.com>,
        "mail@srajiv.net" <mail@srajiv.net>,
        "tpmdd@selhorst.net" <tpmdd@selhorst.net>,
        "tpmdd@sirrix.com" <tpmdd@sirrix.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v2] add xen-tpmfront.ko: Xen Virtual TPM frontend driver
Message-ID: <20121116154451.GM22320@phenom.dumpdata.com>
References: <1352730598-13904-1-git-send-email-matthew.fioravante@jhuapl.edu>
 <20121112163052.GA9575@phenom.dumpdata.com>
 <50A13039.2070909@jhuapl.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A13039.2070909@jhuapl.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 12:22:01PM -0500, Matthew Fioravante wrote:
> On 11/12/2012 11:30 AM, Konrad Rzeszutek Wilk wrote:
> >On Mon, Nov 12, 2012 at 09:29:58AM -0500, Matthew Fioravante wrote:
> >>This patch ports the xen vtpm frontend driver for linux
> >>from the linux-2.6.18-xen.hg tree to linux-stable. This
> >>driver is designed be used with the mini-os tpmback driver
> >>in Xen as part of the new mini-os virtual tpm subsystem.
> >>See docs/misc/vtpm.txt in Xen and the xen-devel mailing list
> >>for details.
> >I didn't look in details but off the bat - you are missing
> >the Documentation/../sysfs file.
> It looks like Kent submitted a patch that documents sysfs generically
> for all of the TPM drivers.

Great!
> >
> >I still think you should include the full vtpm.txt in this
> >patch description and refer at the end to the docs/misc/vtpm.txt
> >in Xen as the source for the up-to-date version.
> The current docs/misc/vtpm.txt in Xen is still the old version. I've
> just written a new one and am reviewing it. It will come in the next
> resubmission of my vtpm patches to xen. I'll include the text here
> for the next resubmission of this patch as well.

Fantastic. Thank you.
> 
> 


