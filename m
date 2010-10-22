Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab0JVIzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:55:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:49875 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab0JVIzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:55:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,222,1286175600"; 
   d="scan'208";a="849949399"
Subject: Re: [PATCH 0/9] ACPI, APEI patches for 2.6.37
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1010220147560.27300@localhost.localdomain>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
	 <alpine.LFD.2.00.1010220147560.27300@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 16:55:42 +0800
Message-ID: <1287737742.2862.241.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 13:50 +0800, Len Brown wrote:
> On Wed, 20 Oct 2010, Huang Ying wrote:
> 
> > [PATCH 2/9] Add lock-less version of bitmap_set/clear
> > [PATCH 3/9] lock-less NULL terminated single list implementation
> > [PATCH 4/9] lock-less general memory allocator
> 
> What kinds of tests has this lockless lib code been subject to?

These code are used by GHES only now. We have a test suite for GHES.
These code works well for GHES.

At the same time, we have test code dedicated for these lib too,
including stress testing.

> This is generic code, does it play on multiple architectures?

We have tested the code on x86_64 and i386 architectures. For some other
architectures, we have done compile testing. The code is quite simple,
so I think it should run properly on other architectures too.

Best Regards,
Huang Ying


