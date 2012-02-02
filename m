Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2BBJqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:46:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962Ab2BBJqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:46:51 -0500
Date: Thu, 2 Feb 2012 10:46:50 +0100 (CET)
From: Richard Guenther <rguenther@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jakub Jelinek <jakub@redhat.com>, Torvald Riegel <triegel@redhat.com>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-ia64@vger.kernel.org, dsterba@suse.cz, ptesarik@suse.cz,
        gcc@gcc.gnu.org
Subject: Re: Memory corruption due to word sharing
In-Reply-To: <CA+55aFwG7BoFg-zaER7=hiamX62_zZCQhB_A+edHaK9Sj7Ga0g@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1202021045100.4999@zhemvz.fhfr.qr>
References: <20120201151918.GC16714@quack.suse.cz> <CA+55aFy55Q=+pFCZcS9cOM6SL+ZT3sNDB+c4qFvVqwwSpTqJ7g@mail.gmail.com> <1328118174.15992.6206.camel@triegel.csb> <20120201194025.GG6148@sunsite.ms.mff.cuni.cz> <CA+55aFzVWjqcs1zRF-93_9yHRDS-YgmpgFTzACw6HQ-059U06Q@mail.gmail.com>
 <CA+55aFwG7BoFg-zaER7=hiamX62_zZCQhB_A+edHaK9Sj7Ga0g@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012, Linus Torvalds wrote:

> IT IS A GCC BUG.

I think you are wrong when you assume that we think it is not a bug.
Repeating it repeatedly in all-caps doesn't make the fix appear
faster though.

Richard.
