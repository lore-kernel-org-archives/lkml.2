Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1C2TIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:08:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549Ab1C2TIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:08:35 -0400
MIME-Version: 1.0
In-Reply-To: <4D922B35.9050107@kernel.org>
References: <alpine.LFD.2.00.1103282048370.2774@localhost6.localdomain6>
 <AANLkTintrwhwbyZGxX1Eecg9ZXo+NgRzTwyyMyzt1JGR@mail.gmail.com>
 <alpine.LFD.2.00.1103282210590.2774@localhost6.localdomain6>
 <alpine.LFD.2.00.1103282227510.2774@localhost6.localdomain6>
 <AANLkTin7Uc=LzZdD4Waj8GF24Nzi2ccUL+RLtk+fBc=g@mail.gmail.com> <4D922B35.9050107@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 29 Mar 2011 12:08:13 -0700
Message-ID: <AANLkTikRGYPJdyxXCJjxNXHgddSjSZ-FQKKjAA=nDzDj@mail.gmail.com>
Subject: Re: [GIT pull] irq cleanups for .39
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <florian@openwrt.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 11:55 AM, H. Peter Anvin <hpa@kernel.org> wrote:
>
> My concern with that is that indexing services come and go [..]

I understand the _theoretical_ argument.

But when theory and practice clash, theory is worth sh*t.

And in practice, those message-ID's are worthless. Nobody is going to
take the time to look them up.

If you want real permanence and ease of access, JUST QUOTE THE THING
YOU POINTED TO.

And if it's not important enough to quote, make it at least be useful,
obvious, and simple: make it a real web link.

Don't do the idiotic useless message-ID thing. Pick one of the two
options above, not the crazy good-for-nothing one.

                   Linus
