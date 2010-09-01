Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab0IAVdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 17:33:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36742 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0IAVdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 17:33:42 -0400
Date: Wed, 1 Sep 2010 23:33:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] [arch-x86] Allow SRAT integrity check to be skipped
Message-ID: <20100901213337.GA8844@basil.fritz.box>
References: <20100901213318.19353.54619.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901213318.19353.54619.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 02:33:18PM -0700, Peter P Waskiewicz Jr wrote:
> On certain BIOSes, SRAT enumeration isn't exported correctly.
> This leads to NUMA node enumeration failure, and causes the kernel
> to fall back onto a single node treated as flat memory.  This
> can happen on large, multi-socket systems (4 or more sockets), and
> becomes problematic for performance.
> 
> This patch adds a boot parameter to allow a kernel to be booted
> with the option to skip the SRAT check.  There are BIOSes in
> production that have these failures, so this will allow people
> in the field to work around these BIOS issues.

Looks good.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi

