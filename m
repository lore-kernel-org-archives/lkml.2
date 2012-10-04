Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab2JDTmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:42:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46241 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab2JDTl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:41:59 -0400
Date: Thu, 4 Oct 2012 20:41:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        Mikael Starvik <starvik@axis.com>,
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
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 1/4] Clean up the long arch list for the UID16 config
	option
Message-ID: <20121004194131.GA4625@n2100.arm.linux.org.uk>
References: <1349282666-32100-1-git-send-email-catalin.marinas@arm.com> <1349282666-32100-2-git-send-email-catalin.marinas@arm.com> <20121003151505.8d59b646.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003151505.8d59b646.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 03:15:05PM -0700, Andrew Morton wrote:
> Guys, don't do this.  Either put the new item into a randomly-chosen
> position or, probably better, alphanumerically sort the list.

I've been telling people to alphanumerically sort Kconfig select
options for some time, but as normal, no one's listening.
