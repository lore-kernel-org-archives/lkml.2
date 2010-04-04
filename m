Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab0DDIxp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 04:53:45 -0400
Received: from 8bytes.org ([88.198.83.132]:58256 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab0DDIxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 04:53:39 -0400
Date: Sun, 4 Apr 2010 10:53:38 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Bernhard Walle <bernhard@bwalle.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nhorman@redhat.com,
       nhorman@tuxdriver.com, Joerg Roedel <joerg.roedel@amd.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
Message-ID: <20100404085338.GU24846@8bytes.org>
References: <20100403012751.834020949@sous-sol.org> <20100403012820.229410717@sous-sol.org> <20100403174128.GQ24846@8bytes.org> <m1vdc8juju.fsf@fess.ebiederm.org> <4BB83EAE.5090609@bwalle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB83EAE.5090609@bwalle.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 04, 2010 at 09:24:30AM +0200, Bernhard Walle wrote:
> Am 03.04.10 19:49, schrieb Eric W. Biederman:
> > Not a problem.  We require a lot of things of the kdump kernel,
> > and it is immediately apparent in a basic sanity test.
> 
> Also, in most cases (for example: distribution kernels), the kdump
> kernel nowadays is identical to the running kernel. So, if the running
> kernel has IOMMU support, the kdump kernel also has.

Yes, I know. But is that a requirement for kexec? If not we still
potentially have this problem. It is a smaller problem than
data-corruption caused by in-flight dma because most
people^Wdistributions indeed use the same kernel for normal boot and
kexec, thats true.

	Joerg

