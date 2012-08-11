Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab2HKKny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 06:43:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:37805 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab2HKKnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 06:43:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,749,1336374000"; 
   d="scan'208";a="197649686"
Date: Sat, 11 Aug 2012 03:43:52 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Betty Dall <betty.dall@hp.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, pci: Fix all early PCI scans to check the vendor ID
 first
Message-ID: <20120811104352.GI2644@tassilo.jf.intel.com>
References: <1344464246-14618-1-git-send-email-andi@firstfloor.org>
 <1344551691.10751.12.camel@ejdallLaptop>
 <50259FCE.4070205@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50259FCE.4070205@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 04:57:02PM -0700, H. Peter Anvin wrote:
> On 08/09/2012 03:34 PM, Betty Dall wrote:
> > 
> > I thought this should be a break instead of a continue since the code
> > does a break if the class is 0xffffffff. If the function does not have a
> > valid VENDOR_ID, then the remaining function numbers do not have to be
> > scanned because functions are required to be implemented in order (no
> > skipping a function number.)
> > 
> 
> Is that true?  This is certainly not true in PCI in general: there is
> required to be a function 0, but there is no guarantee that functions
> 1-7 don't have gaps.

These scans are for special known devices, presumably true for them.

Anwyays if you don't like it please use v1 of the patch.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
