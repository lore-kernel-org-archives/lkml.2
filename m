Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0IMUD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:03:58 -0400
Received: from ist.d-labs.de ([213.239.218.44]:35259 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab0IMUD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:03:57 -0400
Date: Mon, 13 Sep 2010 22:03:55 +0200
From: Florian Mickler <florian@mickler.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: don't compile with gcc-3.3.3
Message-ID: <20100913220355.35f7ced7@schatten.dmk.lab>
In-Reply-To: <4C8E82F9.3080805@zytor.com>
References: <1284366708-30154-1-git-send-email-florian@mickler.org>
	<1284367195.2275.29.camel@laptop>
	<4C8E49B7.7040104@zytor.com>
	<20100913182105.7463dd99@schatten.dmk.lab>
	<20100913182838.70aa0964@schatten.dmk.lab>
	<4C8E5E97.6070908@zytor.com>
	<20100913204244.55524e22@schatten.dmk.lab>
	<4C8E82F9.3080805@zytor.com>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 13:00:57 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 09/13/2010 11:42 AM, Florian Mickler wrote:
> > 
> > I can imagine that even without having expirienced anything alike :) 
> > 
> > Should I then resend this RFC-Patch updated to abort the x86-build for
> > gcc -lt 3.4?
> > 
> 
> I'm doing a patch series which is a little more complete; I'll post it
> shortly.
> 
> 	-hpa

ok, cool. 

Regards,
Flo
