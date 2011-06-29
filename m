Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1F2Jvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:51:37 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:3282 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab1F2Jvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:51:31 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jun 2011 05:51:31 EDT
X-SpamScore: -21
X-BigFish: VPS-21(zz936eK1432N98dKzz1202hzz15d4Rz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNJPCC-01-BFQ-02
X-M-MSG: 
Date: Wed, 29 Jun 2011 11:36:10 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Joerg Roedel <joro@8bytes.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Avi Kiviti <avi@redhat.com>
Subject: Re: [PATCH 0/5] perf support for amd guest/host-only bits v2
Message-ID: <20110629093610.GL13255@amd.com>
References: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
 <20110628161000.GF29299@8bytes.org>
 <1309338174.6701.929.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1309338174.6701.929.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 05:02:54AM -0400, Peter Zijlstra wrote:
> On Tue, 2011-06-28 at 18:10 +0200, Joerg Roedel wrote:
> > On Fri, Jun 17, 2011 at 03:37:29PM +0200, Joerg Roedel wrote:
> > > this is the second version of the patch-set to support the AMD
> > > guest-/host only bits in the performance counter MSRs. Due to lack of
> > > time I havn't looked into emulating support for this feature on Intel or
> > > other architectures, but the other comments should be worked in. The
> > > changes to v1 include:
> > > 
> > > 	* Rebased patches to v3.0-rc3
> > > 	* Allow exclude_guest and exclude_host set at the same time
> > > 	* Reworked event-parse logic for the new exclude-bits
> > > 	* Only count guest-events per default from perf-kvm
> > 
> > Hi Peter, Ingo,
> > 
> > have you had a chance to look at this patch-set? Are any changes
> > required?
> 
> I would feel a lot more comfortable by having it implemented on all of
> x86 as well as at least one !x86 platform. Avi graciously volunteered
> for the Intel bits.

Ok, since no changes are required from my side then, how about adding
support for more hardware successively like it was done for perf-kvm?

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

