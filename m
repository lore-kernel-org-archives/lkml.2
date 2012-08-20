Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab2HTUEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:04:39 -0400
Received: from mail.x86-64.org ([217.9.48.20]:54557 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab2HTUEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:04:37 -0400
Date: Mon, 20 Aug 2012 22:04:26 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 00/11] x86/microcode: Early load microcode
Message-ID: <20120820200426.GA15006@aftab.osrc.amd.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <20120820153927.GB8623@aftab.osrc.amd.com>
 <50328722.9060009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50328722.9060009@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 11:51:14AM -0700, H. Peter Anvin wrote:
> Not really, but that isn't even Fenghua's fault.

Of course it isn't - I was simply pointing out that this is something
that should be fixed at some point in time, when someone needs a project
over an otherwise eventless weekend :-).

> The cpu directory was originally for cpu detection.  The whole kernel/
> directory, of course, is a morass that might as well be called "misc".
> Some things are legitimately there -- mainly the syscall table and
> things that mirror the global kernel/ -- but a ton of stuff doesn't make
> any sense there.
> 
> Reorganizing the kernel/ directory and promoting cpu up one level would

Yep, arch/x86/cpu, should contain all cpu-related stuff.

> make that make more sense.  The pci and irq code are examples of things
> that could use their own directories.

Yep.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
