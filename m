Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965065Ab2EYU3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:29:44 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:23713 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932Ab2EYU3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:29:40 -0400
Date: Fri, 25 May 2012 22:29:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/4] [-next] Makefile: Do not call cc-option before
	including the arch's Makefile
Message-ID: <20120525202937.GA22903@merkur.ravnborg.org>
References: <1336855148-18817-1-git-send-email-geert@linux-m68k.org> <20120520092744.GA21341@merkur.ravnborg.org> <4FBF7B34.2080506@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBF7B34.2080506@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 02:29:40PM +0200, Michal Marek wrote:
> Dne 20.5.2012 11:27, Sam Ravnborg napsal(a):
> > On Sat, May 12, 2012 at 10:39:05PM +0200, Geert Uytterhoeven wrote:
> >> On architectures that setup CROSS_COMPILE in their arch/*/Makefile
> >> (blackfin, h8300, m68k, mips, parisc, score, sh, tile, unicore32, xtensa),
> >> cc-option may check against the wrong compiler, causing errors like
> >>
> >> cc1: error: unrecognized command line option "-fno-ipa-cp-clone"
> >>
> >> if the host gcc supports -fno-ipa-cp-clone, while the cross compiler
> >> doesn't support that option.
> >>
> >> Move the CONFIG_READABLE_ASM section below the inclusion of the arch's
> >> Makefile to fix this.
> >>
> >> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >> Cc: Andi Kleen <ak@linux.intel.com>
> >> Cc: H. Peter Anvin <hpa@zytor.com>
> >> Cc: Michal Marek <mmarek@suse.cz>
> >> Cc: linux-kbuild@vger.kernel.org
> > 
> > Michal - was this serie ever applied to kbuild?
> 
> The first patch has to go to the tip tree, where the CONFIG_READABLE_ASM
> option is introduced.
OK - I had not seen this.

So tip-folks - please apply this.

	Sam
