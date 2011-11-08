Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab1KHVPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 16:15:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58118 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1KHVPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 16:15:08 -0500
Date: Tue, 8 Nov 2011 21:14:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, rmallon@gmail.com,
        Nikolaus Voss <n.voss@weinmann.de>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, ben-linux@fluff.org, khali@linux-fr.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
Message-ID: <20111108211442.GK12913@n2100.arm.linux.org.uk>
References: <7bdd6b456b0e055441cb25634c8cb6d483718f6c.1320753142.git.n.voss@weinmann.de> <20111108144115.GH20728@legolas.emea.dhcp.ti.com> <4EB9477E.8070002@atmel.com> <20111108152343.GJ20728@legolas.emea.dhcp.ti.com> <20111108182955.GH12913@n2100.arm.linux.org.uk> <20111108184447.GB24399@legolas.emea.dhcp.ti.com> <20111108185525.GI12913@n2100.arm.linux.org.uk> <20111108190200.GC24399@legolas.emea.dhcp.ti.com> <20111108193930.GJ12913@n2100.arm.linux.org.uk> <20111108195854.GD24399@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108195854.GD24399@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 09:58:55PM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Nov 08, 2011 at 07:39:30PM +0000, Russell King - ARM Linux wrote:
> > But, that's something very different from your statement in your previous
> > message about my alleged stance on *all* asm/*.h includes in drivers,
> > which is FALSE.
> 
> http://marc.info/?l=linux-arm-kernel&m=132077795410718&w=2
> 
> I don't see me complaining about *all* headers anywhere in that message.
> I did generalize, but I didn't stated you were complaining about *all*
> headers. Go back and read it for yourself.

I really can't believe what you're saying.

"You were (actually still is) one of the biggest source of complaints for
drivers using <mach/*> and <asm/*> includes and now you're changing your
mind ?"

That's an exact quote.

That statement is very clear in its meaning - and it doesn't match your
assertion that it doesn't mean "all" because it makes no distinction what
so ever between any of those header files.

> You see ? I was asking $author to try and use some revision register in
> order to apply erratas instead of using cpu_is_at91rm9200().

For fuck sake, - AND AGAIN - I was asking you to *qualify* your fucking
statement.  It was you who then launched an attack about irrelevant junk
like what includes and so forth.

You must be drunk this evening.  Please come back once you've sobered up.
