Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0DCTNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 15:13:21 -0400
Received: from 8bytes.org ([88.198.83.132]:52671 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab0DCTNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 15:13:16 -0400
Date: Sat, 3 Apr 2010 21:13:14 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>,
       nhorman@redhat.com, nhorman@tuxdriver.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
Message-ID: <20100403191314.GR24846@8bytes.org>
References: <20100403012751.834020949@sous-sol.org> <20100403012820.229410717@sous-sol.org> <20100403174128.GQ24846@8bytes.org> <m1vdc8juju.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vdc8juju.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 03, 2010 at 10:49:09AM -0700, Eric W. Biederman wrote:
> Joerg Roedel <joro@8bytes.org> writes:

> > Another problem: This also breaks if the kdump kernel has no
> > iommu-support.
> 
> Not a problem.  We require a lot of things of the kdump kernel,
> and it is immediately apparent in a basic sanity test.

Only if the sanity test is done on an iommu machine which I don't want
to rely on.

	Joerg

