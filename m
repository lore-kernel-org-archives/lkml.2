Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab2JDTpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:45:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62232 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab2JDTph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:45:37 -0400
MIME-Version: 1.0
In-Reply-To: <20121004194131.GA4625@n2100.arm.linux.org.uk>
References: <1349282666-32100-1-git-send-email-catalin.marinas@arm.com>
	<1349282666-32100-2-git-send-email-catalin.marinas@arm.com>
	<20121003151505.8d59b646.akpm@linux-foundation.org>
	<20121004194131.GA4625@n2100.arm.linux.org.uk>
Date: Thu, 4 Oct 2012 21:45:35 +0200
X-Google-Sender-Auth: 5ipAw845QOBBwW3NFt6UYC3yuwo
Message-ID: <CAMuHMdWiPLdw3+iKJZRb0bR5seTDz1jTuiF2bV=WvAiyXJz3CQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] Clean up the long arch list for the UID16 config option
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 9:41 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Oct 03, 2012 at 03:15:05PM -0700, Andrew Morton wrote:
>> Guys, don't do this.  Either put the new item into a randomly-chosen
>> position or, probably better, alphanumerically sort the list.
>
> I've been telling people to alphanumerically sort Kconfig select
> options for some time, but as normal, no one's listening.

Anyone who cares to sort the existing ones "at the end of the merge window",
and teaches checkpatch to enforce it for new ones?

The next step is #include order...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
