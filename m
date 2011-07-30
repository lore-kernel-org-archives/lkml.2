Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab1G3SVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 14:21:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752333Ab1G3SVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 14:21:10 -0400
MIME-Version: 1.0
In-Reply-To: <1312047959.20898.489.camel@calx>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
 <1311971867-25124-2-git-send-email-hpa@linux.intel.com> <1311974171.20898.393.camel@calx>
 <CA+55aFwMGwVsD1Gexahio2pWd0PpaHAbvFroB3w0=JOQf1zQ_A@mail.gmail.com> <1312047959.20898.489.camel@calx>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Jul 2011 08:20:36 -1000
Message-ID: <CA+55aFyhdSADSuc2Honu0HG4zLQ7JtovsiTonfA=Cu70jqrFRQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
To: Matt Mackall <mpm@selenic.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 7:45 AM, Matt Mackall <mpm@selenic.com> wrote:
>
> Did you even look at these patches?

Umm. My exact point about the email was that we should if anything
change Peter's patch *away* from some kind of abstracted driver
interface. But that was what you were arguing for, and that was what I
was dismissing.

So when you argue for not taking the patches because you want a
generic interface, I tell you that the argument is bogus.

Now, if you now argue that we should make it closer, and not take
Peter's patches for *that* reason, then I'd be in whole-hearted
agreement with you.

Which way is it?

                Linus
