Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab0JKVNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 17:13:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab0JKVNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 17:13:10 -0400
Date: Mon, 11 Oct 2010 17:12:55 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH -v3 5/6] x86, NMI, treat unknown NMI as hardware error
Message-ID: <20101011211255.GA23882@redhat.com>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
 <1286606987-19879-5-git-send-email-ying.huang@intel.com>
 <20101010150713.3cd3eed2@lxorguk.ukuu.org.uk>
 <20101010141311.GB26728@basil.fritz.box>
 <20101011210829.GA28823@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101011210829.GA28823@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 05:08:29PM -0400, Don Zickus wrote:
> On Sun, Oct 10, 2010 at 04:13:11PM +0200, Andi Kleen wrote:
> > > > These systems are identified via the presentation of APEI HEST or
> > > > some PCI ID of the host bridge. The PCI ID of host bridge instead of
> > > > DMI ID is used, so that the checking can be done based on the platform
> > > > type instead of motherboard. This should be simpler and sufficient.
> > > > 
> > > > The method to identify the platforms is designed by Andi Kleen.
> > > 
> > > Why not make the new flag also a boot option so you can force it on for
> > > platforms where we don't auto whitelist it.
> > 
> > You can already set it at run time using sysctl.
> > 
> > echo 1 > /proc/sys/kernel/panic_on_unrecovered_nmi
> > echo 1 > /proc/sys/kernel/panic_on_io_nmi
> 
> I get the impression Alan was talking about the option
> 
> unknown_nmi_as_hwerr
> 
> which isn't hooked into a sysctl but will cause machines to panic.

Gah.  disregard this, my brain is tired from a long day.

Cheers,
Don
