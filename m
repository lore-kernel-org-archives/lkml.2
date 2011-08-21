Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1HUWro (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 18:47:44 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:55338 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1HUWrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:47:43 -0400
Date: Mon, 22 Aug 2011 07:47:38 +0900
From: Simon Horman <horms@verge.net.au>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: konrad.wilk@oracle.com, ian.campbell@citrix.com, vgoyal@redhat.com,
        olaf@aepfle.de, kexec@lists.infradead.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] kexec-tools: Xen fixes and cleanups
Message-ID: <20110821224737.GF2300@verge.net.au>
References: <20110821135029.GA17323@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110821135029.GA17323@router-fw-old.local.net-space.pl>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 03:50:29PM +0200, Daniel Kiper wrote:
> Hi,
> 
> I am sending some Xen specific fixes and cleanups for kexec-tools.
> These patches applies to current kexec-tools git tree.
> 
> Full list of fixes and cleanups:
>   - xen: Take into account Xen control interface changes since Xen Ver. 4.1,
>   - kexec: Export compare_ranges() function from firmware_memmap.c module,
>   - kexec/arch/i386: Rename fixup_memory_ranges_sysfs() to fixup_memory_ranges(),
>   - kexec/arch/i386: Add get_memory_ranges_xen() function.

Thanks Daniel,

all applied.

