Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab0LNEnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 23:43:55 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:47685 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab0LNEnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 23:43:53 -0500
Date: Mon, 13 Dec 2010 23:43:47 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v4 0/3] ACPI, APEI,
 Report GHES error information via printk
In-reply-to: <1291688551-14395-1-git-send-email-ying.huang@intel.com>
Message-id: <alpine.LFD.2.00.1012132343100.16730@x980>
References: <1291688551-14395-1-git-send-email-ying.huang@intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Huang Ying wrote:

> The recent consensus is that hardware error should be reported via printk.
> This patch adds printk support to APEI GHES.
> 
> v4:
> 
> - Remove pr_pfx, use printk directly

v4 applied to acpi-test

thanks,
Len Brown, Intel Open Source Technology Center

> 
> v3:
> 
> - Add document for output format per Andrew's comments
> - Move pr_pfx into printk.h, hope it is useful for others too
> - Fixes some issues according to comments
> 
> v2:
> 
> - Some minor adjustment of PCIe error section definition and printk format
> 
> [PATCH -v4 1/3] Add CPER PCIe error section structure and constants definition
> [PATCH -v4 2/3] ACPI, APEI, Add APEI generic error status printing support
> [PATCH -v4 3/3] ACPI, APEI, Report GHES error information via printk
> 
