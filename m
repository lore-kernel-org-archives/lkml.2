Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab1KLAro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 19:47:44 -0500
Received: from sous-sol.org ([216.99.217.87]:57645 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754803Ab1KLArn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 19:47:43 -0500
Date: Fri, 11 Nov 2011 16:47:36 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: Default to non-coherent for domains
 unattached to iommus
Message-ID: <20111112004736.GQ14486@sequoia.sous-sol.org>
References: <20111111224849.9756.13368.stgit@bling.home>
 <1321058267.2006.21.camel@shinybook.infradead.org>
 <20111112004513.GP14486@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111112004513.GP14486@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Wright (chrisw@sous-sol.org) wrote:
> * David Woodhouse (dwmw2@infradead.org) wrote:
> > So if you were to ditch the whole idea of a per-domain runtime update,
> > and instead calculate a global value for 'iommu_coherency' at boot time,
> > by iterating over for_each_active_iommu()¹, I think that would be a
> > better way to deal with the issue. And you *could* really call that a
> > 'fix'.
> > 
> > Make sense?
> 
> Ideally, yes.  Not sure we can practically do it though.  Would have to
> be sure we force incoherent access mode for the busted hw.

Forgot to mention, the simple patch may be the better choice for -stable
(assuming the page table mapping issue...isn't).
