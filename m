Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab1BWUTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:19:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab1BWUTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:19:36 -0500
Subject: Re: [RFC PATCH 1/3] Weight-balanced tree
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        xiaoguangrong@cn.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4D653F1D.2090106@redhat.com>
References: <20110222183822.22026.62832.stgit@s20.home>
	 <20110222185456.22026.28200.stgit@s20.home>  <4D6506FB.2090809@redhat.com>
	 <1298480563.18387.6.camel@x201>  <4D653F1D.2090106@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 13:19:27 -0700
Message-ID: <1298492367.18387.59.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 19:08 +0200, Avi Kivity wrote:
> On 02/23/2011 07:02 PM, Alex Williamson wrote:
> > >
> > >  obj-$(CONFIG_WEIGHT_BALANCED_TREE) += wbtree.o
> > >
> > >  then kvm can select it, and the impact on non-kvm kernels is removed.
> >
> > Then we'd have issues trying to build an external kvm module for a
> > pre-existing non-kvm kernel.  Do we care?
> 
> Officially, no.
> 
> What we typically do in these cases is copy the code into the kvm-kmod 
> compatibility layer and compile it if the kernel doesn't supply it (like 
> all older kernels regardless of config).
> 
> > If we were to take such a
> > path, I think the default should be on, kvm would depend on it, but we
> > could add an option to disable it for EMBEDDED/EXPERT.  Thanks,
> 
> That would work as well.

In retrospect, I suppose it doesn't really make sense to have it
compiled in "just in case".  I'll follow your first suggestion.  Thanks,

Alex

