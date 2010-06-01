Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab0FAP7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:59:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932118Ab0FAP7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:59:39 -0400
Date: Tue, 1 Jun 2010 08:55:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       "arjan@infradead.org" <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Documentation/timers/hpet_example.c: only build on X64
In-Reply-To: <4C0470BE.6040709@oracle.com>
Message-ID: <alpine.LFD.2.00.1006010852470.3637@i5.linux-foundation.org>
References: <20100528113514.GA3686@osiris.boeblingen.de.ibm.com> <4C0470BE.6040709@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 31 May 2010, Randy Dunlap wrote:
> 
> We should only build hpet_example on X64, where it is
> implemented.  It can cause build errors on other arch-es.

Both the subject and the body say "X64" (don't use that, btw, it's x86-64, 
please), but the patch itself says CONFIG_X86.

So what is it? Is it any x86, is it just 64-bit, or what? 

So if it's any x86, then please say so in the explanation. And if it's 
really just x86-64, then use CONFIG_X86_64 as the config variable (and 
x86-64 rather than X64 in the commentary).

			Linus
