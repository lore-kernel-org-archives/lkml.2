Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2JDKDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:03:40 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36391 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209Ab2JDKDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:03:38 -0400
Date: Thu, 4 Oct 2012 11:00:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/4] Clean up the long arch list for the UID16 config
 option
Message-ID: <20121004100029.GC18338@arm.com>
References: <1349282666-32100-1-git-send-email-catalin.marinas@arm.com>
 <1349282666-32100-2-git-send-email-catalin.marinas@arm.com>
 <20121003151505.8d59b646.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003151505.8d59b646.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 11:15:05PM +0100, Andrew Morton wrote:
> On Wed,  3 Oct 2012 17:44:23 +0100
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > This patch introduces HAVE_UID16 config option and selects it in
> > corresponding architecture Kconfig files. UID16 now only depends on
> > HAVE_UID16.
> 
> patching file arch/arm/Kconfig
> Hunk #1 FAILED at 49.
...
> This is a pet peeve of mine.  Any time there's a long list of items
> (header file inclusions, kconfig entries, array initalisers, etc) and
> someone wants to add a new item, they *always* go and stick it at the
> end of the list.
> 
> Which is exactly where everyone else applies their modifications.  The
> whole thing is carefully set up to maximise the number of conflicts.
> 
> Guys, don't do this.  Either put the new item into a randomly-chosen
> position or, probably better, alphanumerically sort the list.

I will repost a v2 with randomly chosen position. Sorting is better but
it would cause even more conflicts at this stage. It would be suitable
for a later -rc clean-up though.

-- 
Catalin
