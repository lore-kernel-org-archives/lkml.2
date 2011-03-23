Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1CWHtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 03:49:40 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.184]:51391
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752981Ab1CWHti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 03:49:38 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432N98dNzz1202hzz15d4Rz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LII319-02-0VB-02
X-M-MSG: 
Date: Wed, 23 Mar 2011 08:48:45 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>, Avi Kivity <avi@redhat.com>,
        Kay Sievers <kay.sievers@suse.de>, Dave Jones <davej@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 3/6] PCI / Intel IOMMU: Use syscore_ops instead of
 sysdev class and sysdev
Message-ID: <20110323074845.GE20444@amd.com>
References: <201103100131.58206.rjw@sisk.pl>
 <201103220036.17824.rjw@sisk.pl>
 <20110322105738.GC20444@amd.com>
 <201103222307.21983.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201103222307.21983.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 06:07:21PM -0400, Rafael J. Wysocki wrote:
> On Tuesday, March 22, 2011, Joerg Roedel wrote:
> > On Mon, Mar 21, 2011 at 07:36:17PM -0400, Rafael J. Wysocki wrote:
> > >  drivers/pci/intel-iommu.c |   38 +++++++++-----------------------------
> > >  1 file changed, 9 insertions(+), 29 deletions(-)
> > 
> > Looks good.
> 
> May I take that as an ACK?

Sure :-)
 
> > I prepare a patch to convert AMD IOMMU to syscore_ops too.
> 
> Already done.  :-)
> 
> It's a part of patch [1/6].

I see, saves me work, thanks :-)

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

