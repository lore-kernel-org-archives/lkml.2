Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1F2JE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:04:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48775 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab1F2JEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:04:10 -0400
Subject: Re: [PATCH 0/5] perf support for amd guest/host-only bits v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>
In-Reply-To: <20110628161000.GF29299@8bytes.org>
References: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
	 <20110628161000.GF29299@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 29 Jun 2011 11:02:54 +0200
Message-ID: <1309338174.6701.929.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 18:10 +0200, Joerg Roedel wrote:
> On Fri, Jun 17, 2011 at 03:37:29PM +0200, Joerg Roedel wrote:
> > this is the second version of the patch-set to support the AMD
> > guest-/host only bits in the performance counter MSRs. Due to lack of
> > time I havn't looked into emulating support for this feature on Intel or
> > other architectures, but the other comments should be worked in. The
> > changes to v1 include:
> > 
> > 	* Rebased patches to v3.0-rc3
> > 	* Allow exclude_guest and exclude_host set at the same time
> > 	* Reworked event-parse logic for the new exclude-bits
> > 	* Only count guest-events per default from perf-kvm
> 
> Hi Peter, Ingo,
> 
> have you had a chance to look at this patch-set? Are any changes
> required?

I would feel a lot more comfortable by having it implemented on all of
x86 as well as at least one !x86 platform. Avi graciously volunteered
for the Intel bits.  

Paulus, I hear from benh that you're also responsible for the ppc-kvm
bits, could you possibly find some time to implement this feature for
ppc?
