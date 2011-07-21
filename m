Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab1GUHiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:38:25 -0400
Received: from ozlabs.org ([203.10.76.45]:59179 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab1GUHiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:38:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Marek <mmarek@suse.cz>
Cc: Alessio Igor Bogani <abogani@kernel.org>,
        Jan Beulich <jbeulich@novell.com>,
        Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH] modpost: Fix modpost's license checking V3
In-Reply-To: <4E26F35E.7020700@suse.cz>
References: <CACqU3MUXAOMGQ1nzUrtYPEQAC3U-nuq3YurtNJJLS1hft4ROGA@mail.gmail.com> <1310626276-4541-1-git-send-email-abogani@kernel.org> <4E26F35E.7020700@suse.cz>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 21 Jul 2011 16:16:51 +0930
Message-ID: <87ei1k2kro.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011 17:25:18 +0200, Michal Marek <mmarek@suse.cz> wrote:
> On 14.7.2011 08:51, Alessio Igor Bogani wrote:
> > The commit f02e8a6 sorts symbols placing each of them in its own elf section.
> > The sorting and merging into the canonical sections are done by the linker.
> > Unfortunately modpost to generate Module.symvers file parses vmlinux
> > (already linked) and all modules object files (which aren't linked yet).
> > These aren't sanitized by the linker yet. That breaks modpost that can't
> > detect license properly for modules. This patch makes modpost aware of
> > the new exported symbols structure.
> >
> > Thanks to Arnaud Lacombe<lacombar@gmail.com>  and Anders Kaseorg
> > <andersk@ksplice.com>  for providing useful suggestions about code.
> >
> > This work was supported by a hardware donation from the CE Linux Forum.
> >
> > Reported-by: Jan Beulich<jbeulich@novell.com>
> > Signed-off-by: Alessio Igor Bogani<abogani@kernel.org>
> > ---
> >   scripts/mod/modpost.c |   29 ++++++++++++++++++++++++++++-
> >   1 files changed, 28 insertions(+), 1 deletions(-)
> 
> Rusty, will you take this patch or should I apply it to kbuild-2.6.git?

I took it.

Thanks,
Rusty.
