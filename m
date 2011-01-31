Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab1AaLhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:37:42 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36592 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab1AaLhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:37:40 -0500
Date: Mon, 31 Jan 2011 06:36:57 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        benh@kernel.crashing.org
Subject: Re: [PATCH 2/3] dt: Remove obsolete description of powerpc boot
 interface
Message-ID: <20110131113657.GC13541@zod.rchland.ibm.com>
References: <20110131073918.9058.37628.stgit@localhost6.localdomain6>
 <20110131074502.9058.11473.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131074502.9058.11473.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 12:45:05AM -0700, Grant Likely wrote:
>32 and 64 bit powerpc support has been merged for a while now, but
>the booting-without-of.txt document still describes 32 bit as not
>supporting multiplatform, which is no longer true.  This patch fixes
>the documentation.
>
>Also remove references to powerpc-specific details outside of section
>I in preparation to add details for other architectures.

There's a line around 500 that starts:

	"The kernel powerpc generic code does..."

Perhaps the powerpc reference should be dropped there?

Also, there are several mentions of "real Open Firmware", which are
probably just fine, and prom_init(), which are probably arch specific.

There is a section that talks about ranges that starts with:

	"For a new 64-bit powerpc board, I...".

Section III 5) has all kinds of powerpc specific stuff.  CHRP,
pSeries, PAPR in the root node.  The references to Apple machines for
examples are probably OK, but it shouldn't make PowerPC items as
explicit requirements.

Section III 5e) references a file that doesn't exist:
arch/ppc64/kernel/setup.c

Section V, paragraph 2 references a file that doesn't exist:
arch/ppc64/kernel/prom.c

Hope that helps you...

josh
