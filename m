Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0IMQ2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:28:41 -0400
Received: from ist.d-labs.de ([213.239.218.44]:55644 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab0IMQ2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:28:40 -0400
Date: Mon, 13 Sep 2010 18:28:38 +0200
From: Florian Mickler <florian@mickler.org>
To: Florian Mickler <florian@mickler.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: don't compile with gcc-3.3.3
Message-ID: <20100913182838.70aa0964@schatten.dmk.lab>
In-Reply-To: <20100913182105.7463dd99@schatten.dmk.lab>
References: <1284366708-30154-1-git-send-email-florian@mickler.org>
	<1284367195.2275.29.camel@laptop>
	<4C8E49B7.7040104@zytor.com>
	<20100913182105.7463dd99@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 18:21:05 +0200
Florian Mickler <florian@mickler.org> wrote:

> On Mon, 13 Sep 2010 08:56:39 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > On 09/13/2010 01:39 AM, Peter Zijlstra wrote:

> > The only reason to not abort the build for gcc 3.3.3 is that soem
> > "enterprise" distros have been shipping gcc 3.3.3 with backported fixes
> > from 3.4, which of course still identifies themselves as gcc 3.3.3, and
> > so technically it is iompossioble to tell if any particular "gcc 3.3.3"
> > is actually broken or not.

What about issuing a warning like 

"gcc 3.3.3 is broken because of bug [bugdescription/url].
if you know your build is not affected by this bug do:
touch .gcc333bugfixNNNN but please be aware that you are 
not supported by the mainline kernel development comunity 
if you do"

and implementing the accompanying logic?

Cheers,
Flo
