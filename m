Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0JDSdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:33:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34477 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab0JDSdI (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 4 Oct 2010 14:33:08 -0400
Date: Mon, 4 Oct 2010 14:30:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        alex.williamson@redhat.com, Alex Nixon <alex.nixon@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Wilcox <willy@linux.intel.com>, Qing He <qing.he@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: [PATCH 17/20] xen/x86/PCI: Add support for the Xen PCI
 subsystem
Message-ID: <20101004183005.GA9860@dumpdata.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
 <1280945955-14229-18-git-send-email-konrad.wilk@oracle.com>
 <20100813162835.12ec7286@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100813162835.12ec7286@virtuousgeek.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > ---
> 
> Fine with me if this stuff goes in with the rest of the Xen bits,
> presumably through the x86 tree.
> 
> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Hey Jesse,

(Sorry for responding so late - I had this in my postponed and then lost
track of time).

Thank you for taking the time to look at it. Since the patches touch both
x86 and xen tree, I was thinking to push these patches to Linus myself.

That is of course once more folks have had a chance to look at the
x86 generic pieces (especially the MSI/MSI-X patch proposed by Stefano:
http://marc.info/?i=1286216015-9710-17-git-send-email-konrad.wilk@oracle.com).
