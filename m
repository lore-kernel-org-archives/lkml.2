Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab1AKOSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:18:09 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:23871 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1AKOSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:18:06 -0500
X-IronPort-AV: E=Sophos;i="4.60,307,1291611600"; 
   d="scan'208";a="130492440"
Subject: Re: [Xen-devel] [PATCH] xen: use PCI interfaces to request IO	 and
 MEM resources on platform device.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Jan Beulich <JBeulich@novell.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4D2C72FA020000780002BB58@vpn.id2.novell.com>
References: <1294746628-20396-1-git-send-email-ian.campbell@citrix.com>
	 <4D2C5FA5020000780002BB21@vpn.id2.novell.com>
	 <1294750884.3831.5866.camel@zakaz.uk.xensource.com>
	 <4D2C72FA020000780002BB58@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 11 Jan 2011 14:18:03 +0000
Message-ID: <1294755483.3831.5872.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 14:10 +0000, Jan Beulich wrote:
> >>> On 11.01.11 at 14:01, Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:
> > The old way was correct circa 2.6.37-rc5 but broken in 2.6.37 final,
> > there were a bunch of (reverts of) PCI resource changes in that window,
> > If I had to make a guess I'd say it was something in there which did it.
> 
> Was it perhaps broken somewhere between -rc5 and -final, but
> not in -final itself?

No I'm working with 2.6.37 final and it is broken there.

> >> I'm mainly asking because if it really addresses some problem,
> >> then unmodified_drivers/linux-2.6/platform-pci/platform-pci.c
> >> in -unstable should probably get updated too.
> > 
> > Assuming the pci_* interfaces exist back as far as we care about for
> > those drivers then I don't see why not to apply it.
> 
> I checked back to .5, where they exist; the question is - how far
> back do we care?

You mean 2.6.5? That's old enough to be the cut off IMHO.

I'm not sure how much actual use these drivers get these days though.

Ian.


