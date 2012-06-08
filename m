Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052Ab2FHJG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:06:27 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36261 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075Ab2FHJG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:06:26 -0400
Date: Fri, 8 Jun 2012 11:06:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: lee.g.rosenbaum@intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jordan.l.justen@intel.com, tglx@linutronix.de, rydberg@euromail.se,
        matt.fleming@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, efi stub: Add .reloc section back into
 image
Message-ID: <20120608090621.GB10841@gmail.com>
References: <1339085121-12760-1-git-send-email-jordan.l.justen@intel.com>
 <tip-743628e868c5992354fc80b4d1e9a6143da1c0e6@git.kernel.org>
 <4FD10CFC.8030000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD10CFC.8030000@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maarten Lankhorst <m.b.lankhorst@gmail.com> wrote:

> Hey,
> 
> Op 07-06-12 20:37, tip-bot for Jordan Justen schreef:
> > Commit-ID:  743628e868c5992354fc80b4d1e9a6143da1c0e6
> > Gitweb:     http://git.kernel.org/tip/743628e868c5992354fc80b4d1e9a6143da1c0e6
> > Author:     Jordan Justen <jordan.l.justen@intel.com>
> > AuthorDate: Thu, 7 Jun 2012 09:05:21 -0700
> > Committer:  H. Peter Anvin <hpa@zytor.com>
> > CommitDate: Thu, 7 Jun 2012 09:52:33 -0700
> >
> > x86, efi stub: Add .reloc section back into image
> >
> > Some UEFI firmware will not load a .efi with a .reloc section
> > with a size of 0.
> >
> > Therefore, we create a .efi image with 4 main areas and 3 sections.
> > 1. PE/COFF file header
> > 2. .setup section (covers all setup code following the first sector)
> > 3. .reloc section (contains 1 dummy reloc entry, created in build.c)
> > 4. .text section (covers the remaining kernel image)
> >
> Scary how some patches arrive a few minutes before you need them.

We are all working hard on perfecting our precog skills!

Thanks,

	Ingo
