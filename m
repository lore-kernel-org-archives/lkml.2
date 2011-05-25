Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab1EYQUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:20:12 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:26801 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab1EYQUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:20:10 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-131.messagelabs.com!1306340400!25583553!8
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.32]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@fluxnic.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 25 May 2011 11:19:59 -0500
Subject: RE: [RFC] ARM Subarchitecture group maintainership
Thread-Topic: [RFC] ARM Subarchitecture group maintainership
Thread-Index: AcwatU6dizU0qiZvQrKffxhM6ClDTAAQiWgg
Message-ID: <0D753D10438DA54287A00B027084269764D323A714@AUSP01VMBX24.collaborationhost.net>
References: <201105181047.17309.arnd@arndb.de>
 <20110525082344.GF22096@pengutronix.de>
In-Reply-To: <20110525082344.GF22096@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 10:47:16AM +0200, Arnd Bergmann wrote:
> This is the draft plan for maintaining the ARM subarchitectures in a common
> tree, as a way to help coordinate the upstream merging of the
> arch/arm/{plat,mach}-* changes into Linus' tree.
> 
> This was discussed in great length at the Linaro Developer Summit in Budapest
> last week where we worked out an initial plan. We are modeling the maintainance
> after how the linux-tip tree is used for the x86 architecture, with a set
> of developers that have commit access to one tree on kernel.org and
> have mutual trust in one another. Nicolas Pitre and me are funded
> by Linaro to do the bulk of the work, while Thomas Gleixner will help
> us part-time with his long time architecture maintainance experience.
> Despite the funding by Linaro, this is not a Linaro project and all
> ARM subarchitectures are welcome to go through our tree.
> 
> Russell King's role as ARM maintainer is of course unchanged by this, but
> he has the same commit access to the new tree as the other maintainers and
> is welcome to work in the same tree. We are also open to nominations for
> further people outside of Linaro to join us as committers. Marc Zyngier from
> ARM ltd is one of the candidates that has been suggested and I would also
> like to see someone from Google. We have to find the right balance with the
> number of committers so we get all the work done without stepping on each
> other's toes.
> 
> Our tree will be strictly organized in topic brances so we can feed them
> upstream in the bitesized chunks that Linus likes. The master branch
> is an integration branch that pulls all other branches that are scheduled
> for the next merge window and itself gets integrated into linux-next.
> 
> We will probably not be fully functional during the 2.6.40 merge window,
> but we are trying our best to be useful. For 2.6.41, my hope is that
> we can merge the bulk of the ARM subarchitecture changes through this
> tree. Once Linus is happy with the way that the process works, we can
> mandate that all ARM subarchitecture changes go through our tree, until
> then it stays voluntary.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> 
> ---
> 
> Maintainers: If you are happy with the layout of the process,
> please ack this patch, otherwise please comment.

As co-maintainer of ep93xx

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
