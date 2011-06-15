Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab1FOUjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:39:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:13212 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189Ab1FOUj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:39:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,371,1304319600"; 
   d="scan'208";a="15247934"
Date: Wed, 15 Jun 2011 13:39:27 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xhci: Add reset on resume quirk for asrock p67 host
Message-ID: <20110615203927.GG5382@xanatos>
References: <4DF85A1F.1080001@gmail.com>
 <20110615165842.GB5382@xanatos>
 <4DF8EE62.3060407@gmail.com>
 <20110615195928.GD5382@xanatos>
 <4DF9160D.8090109@gmail.com>
 <20110615203631.GF5382@xanatos>
 <4DF9184A.9030308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF9184A.9030308@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 10:38:34PM +0200, Maarten Lankhorst wrote:
> Hi Sarah,
> 
> Op 15-06-11 22:36, Sarah Sharp schreef:
> > On Wed, Jun 15, 2011 at 10:29:01PM +0200, Maarten Lankhorst wrote:
> >> The asrock p67 xhci controller completely dies on resume,
> >> add a quirk for this, to bring the host back online after a suspend.
> >>
> >> This should be backported to stable kernels as far back as 2.6.34.
> > Why 2.6.34?  Only kernels as old as 2.6.37 had xHCI suspend and resume
> > support.  Before 2.6.37, the xHCI driver would prevent the system from
> > suspending at all.
> Oh my bad, I was just looking at my previous commit, expected
> resume to already be available since xhci was in the kernel for so long.
> 
> Should I resend or will you amend the commit message?

I'll just amend it.  No worries. :)

Sarah Sharp
