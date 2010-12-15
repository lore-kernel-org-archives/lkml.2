Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab0LOClk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 21:41:40 -0500
Received: from relay3.sgi.com ([192.48.152.1]:48865 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752291Ab0LOCli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 21:41:38 -0500
Date: Tue, 14 Dec 2010 20:41:36 -0600
From: Jack Steiner <steiner@sgi.com>
To: Len Brown <lenb@kernel.org>
Cc: hpa@zytor.com, hmh@hmh.eng.br, tony.luck@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
Message-ID: <20101215024136.GB19601@sgi.com>
References: <20101214220932.GA1206@sgi.com> <alpine.LFD.2.00.1012141903210.25387@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012141903210.25387@x980>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 07:04:13PM -0500, Len Brown wrote:
> hmm, my arrandale laptop fails to get into graphics mode w/ this patch 
> applied -- last thing i see is the kernel freeing memory, then black 
> screen.
> 
> thanks,
> Len Brown, Intel Open Source Technology Center

Do you know where the ACPI tables actually reside? In RAM
or in another type of memory.

The original version of this patch made the cacheable mapping
a platform attribute that was set via a function called thru
the x86_platform_ops.  This was intended to minimize the potential
for breaking systems with BIOSes that used non-RAM ACPI tables.
There are a lot of different BIOSes and I'm not even close to
understanding them all.

Wonder if I should resurrect that version of the patch....
