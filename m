Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab0KANxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:53:21 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55909 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab0KANxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:53:20 -0400
Date: Mon, 1 Nov 2010 14:53:32 +0100
From: Borislav Petkov <bp@amd64.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Shaohua Li <shaohua.li@intel.com>, Stephane Eranian <eranian@google.com>,
        Len Brown <len.brown@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.37-rc1: section mismatches
Message-ID: <20101101135332.GA2864@kryptos.osrc.amd.com>
References: <tkrat.725fc810c3a4881e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.725fc810c3a4881e@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 02:43:29PM +0100, Stefan Richter wrote:
> ----
> WARNING: vmlinux.o(.text+0x26e8c): Section mismatch in reference from the function tlb_cpuhp_notify() to the function .cpuinit.text:calculate_tlb_offset()
> The function tlb_cpuhp_notify() references
> the function __cpuinit calculate_tlb_offset().
> This is often because tlb_cpuhp_notify lacks a __cpuinit 
> annotation or the annotation of calculate_tlb_offset is wrong.
> 
> apparently due to commit 932967202182743c01a2eee4bdfa2c42697bc586

First one already fixed: http://git.kernel.org/tip/cf38d0ba7efdc476815768b2b999b27cfae69747

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
