Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab2DKQWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:22:10 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:7621
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932418Ab2DKQWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:22:07 -0400
X-SpamScore: -24
X-BigFish: VPS-24(z6c9Mz1432N98dKzz1202hzz15d4Rz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2BPGM-02-6W9-02
X-M-MSG: 
Date: Wed, 11 Apr 2012 18:21:36 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Ben Hutchings <ben@decadent.org.uk>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ 117/175] iommu/amd: Make sure IOMMU interrupts are re-enabled
 on resume
Message-ID: <20120411162136.GI2428@amd.com>
References: <20120330194849.232840068@linuxfoundation.org>
 <1333423686.443.37.camel@deadeye>
 <20120411154522.GH2428@amd.com>
 <20120411160039.GB31288@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120411160039.GB31288@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 09:00:39AM -0700, Greg KH wrote:
> On Wed, Apr 11, 2012 at 05:45:22PM +0200, Joerg Roedel wrote:
> > Right, this fix is also required for 3.2 and 3.0.
> 
> Wait, what?
> 
> Can someone send me the needed fix, in a new thread as I seem to have
> lost this one :(

No problem. I send you the backported fix for 3.2 and 3.0.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

