Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1GaAaH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:30:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024Ab1GaAaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:30:01 -0400
MIME-Version: 1.0
In-Reply-To: <20110730234630.7270.qmail@science.horizon.com>
References: <20110730234630.7270.qmail@science.horizon.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Jul 2011 14:29:38 -1000
Message-ID: <CA+55aFwdA_6W1GZZG76wVvmDQnEMj3hYBt6Md7GcFE02OkqiVA@mail.gmail.com>
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
To: George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com, tytso@mit.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 1:46 PM, George Spelvin <linux@horizon.com> wrote:
>
> I agree with your second paragraph, but disagree violently with your
> first: Intel provide no way to test their RNG, and the AES-based whitener
> makes it completely private and UNtestable.

Umm.

Guys, if your argument is that you cannot possibly distinguish the
Intel implementation from "true" randomness, then WHAT THE HELL are
you complaining about?

We don't even care. "True randomness" and "something we cannot
possibly even test and distinguish from true randomess" are 100%
equivalent. Stop with the idiotic "we cannot test it" crap. If it
really is indistinguishable from true randomness, nobody will ever
care.

It's that simple. Really.

And if somebody ever figures out that Intel flubbed, and you actually
*can* tell it from true randomness, even then, what's the downside? It
will be practically random anyway, and we'll be mixing it up some
more.

Seriously. This whole discussion just makes me convinced that security
people are so far removed from reality that it's not even relevant any
more.

            Linus
