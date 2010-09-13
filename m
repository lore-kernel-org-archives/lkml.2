Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0IMSmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:42:47 -0400
Received: from ist.d-labs.de ([213.239.218.44]:41274 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab0IMSmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:42:46 -0400
Date: Mon, 13 Sep 2010 20:42:44 +0200
From: Florian Mickler <florian@mickler.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: don't compile with gcc-3.3.3
Message-ID: <20100913204244.55524e22@schatten.dmk.lab>
In-Reply-To: <4C8E5E97.6070908@zytor.com>
References: <1284366708-30154-1-git-send-email-florian@mickler.org>
	<1284367195.2275.29.camel@laptop>
	<4C8E49B7.7040104@zytor.com>
	<20100913182105.7463dd99@schatten.dmk.lab>
	<20100913182838.70aa0964@schatten.dmk.lab>
	<4C8E5E97.6070908@zytor.com>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 10:25:43 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 09/13/2010 09:28 AM, Florian Mickler wrote:
> > 
> > What about issuing a warning like 
> > 
> > "gcc 3.3.3 is broken because of bug [bugdescription/url].
> > if you know your build is not affected by this bug do:
> > touch .gcc333bugfixNNNN but please be aware that you are 
> > not supported by the mainline kernel development comunity 
> > if you do"
> > 
> > and implementing the accompanying logic?
> > 
> 
> URK.
> 
> The workload of maintaining that crap would be astonishing, especially
> for something at the tail end of supportable.
> 
> I don't think that is even remotely realistic.
> 
> 	-hpa

I can imagine that even without having expirienced anything alike :) 

Should I then resend this RFC-Patch updated to abort the x86-build for
gcc -lt 3.4?

Regards,
Flo

