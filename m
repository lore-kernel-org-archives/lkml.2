Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab2BNAjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:39:16 -0500
Received: from ozlabs.org ([203.10.76.45]:46542 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab2BNAjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:39:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Uwe =?utf-8?Q?Klein?= =?utf-8?Q?e-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Anders Kaseorg <andersk@ksplice.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-omap@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] modpost: Fix section warnings for ARM for many compilers
In-Reply-To: <20120213225118.GC31482@n2100.arm.linux.org.uk>
References: <20120213212401.GH1426@atomide.com> <20120213222652.GL14173@pengutronix.de> <20120213225118.GC31482@n2100.arm.linux.org.uk>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 14 Feb 2012 10:59:12 +1030
Message-ID: <878vk6cl5z.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012 22:51:18 +0000, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Mon, Feb 13, 2012 at 11:26:52PM +0100, Uwe Kleine-König wrote:
> > On Mon, Feb 13, 2012 at 01:24:01PM -0800, Tony Lindgren wrote:
> > Maybe:
> > 
> > #ifndef R_ARM_CALL
> > #warning "you're elf.h include is outdated"
> 
> "You are elf.h include is outdated" does not make sense.
> 
> Why are you calling Tony an elf.h include?

Because he knew it would attract the attention of pedants to the patch?
:)

Just do the #ifndef, and skip the warning.  There's not much the poor
user receiving the warning can do about it.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
