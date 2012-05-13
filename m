Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2EMBBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 21:01:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:45571 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544Ab2EMBBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 21:01:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165480906"
Date: Sat, 12 May 2012 18:01:08 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/4] [-next] Makefile: Do not call cc-option before
 including the arch's Makefile
Message-ID: <20120513010108.GD27196@tassilo.jf.intel.com>
References: <1336855148-18817-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336855148-18817-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 10:39:05PM +0200, Geert Uytterhoeven wrote:
> On architectures that setup CROSS_COMPILE in their arch/*/Makefile
> (blackfin, h8300, m68k, mips, parisc, score, sh, tile, unicore32, xtensa),
> cc-option may check against the wrong compiler, causing errors like
> 
> cc1: error: unrecognized command line option "-fno-ipa-cp-clone"
> 
> if the host gcc supports -fno-ipa-cp-clone, while the cross compiler
> doesn't support that option.
> 
> Move the CONFIG_READABLE_ASM section below the inclusion of the arch's
> Makefile to fix this.

Thanks Geert for tracking that down.

Michael, are the patches already in the queue or should I resubmit them?

-Andi
