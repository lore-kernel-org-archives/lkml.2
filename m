Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab2JDTrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:47:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46271 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab2JDTrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:47:08 -0400
Date: Thu, 4 Oct 2012 20:46:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 1/4] Clean up the long arch list for the UID16 config
	option
Message-ID: <20121004194648.GB4625@n2100.arm.linux.org.uk>
References: <1349282666-32100-1-git-send-email-catalin.marinas@arm.com> <1349282666-32100-2-git-send-email-catalin.marinas@arm.com> <20121003151505.8d59b646.akpm@linux-foundation.org> <20121004194131.GA4625@n2100.arm.linux.org.uk> <CAMuHMdWiPLdw3+iKJZRb0bR5seTDz1jTuiF2bV=WvAiyXJz3CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWiPLdw3+iKJZRb0bR5seTDz1jTuiF2bV=WvAiyXJz3CQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 09:45:35PM +0200, Geert Uytterhoeven wrote:
> On Thu, Oct 4, 2012 at 9:41 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Wed, Oct 03, 2012 at 03:15:05PM -0700, Andrew Morton wrote:
> >> Guys, don't do this.  Either put the new item into a randomly-chosen
> >> position or, probably better, alphanumerically sort the list.
> >
> > I've been telling people to alphanumerically sort Kconfig select
> > options for some time, but as normal, no one's listening.
> 
> Anyone who cares to sort the existing ones "at the end of the merge window",
> and teaches checkpatch to enforce it for new ones?

Well, I'll certainly do that for ARM... but how long it'll stay like
that will be very hit and miss...
