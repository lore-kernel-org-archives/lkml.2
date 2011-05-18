Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab1ERIsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 04:48:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50789 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1ERIsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 04:48:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: [RFC] ARM Subarchitecture group maintainership
Date: Wed, 18 May 2011 10:47:16 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@fluxnic.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105181047.17309.arnd@arndb.de>
X-Provags-ID: V02:K0:seqqnGMEJfGhHDVEvXt7Y6RtSqNKgrPeqYlsoCJFeDu
 jPO/Z2YOUVRDRSAiezL+5Y6vAtG9Wb8hZMjt20I4YvXpXSX5a1
 BC0POajBfavgXT9XFKYhMVSnivmAYHs2JCumBhw00ovRIQhj5g
 xcqVWq7RHUk4+pU7wFDl7ykVABVsoVOVQXNVkIKTibvvz2l30a
 nGgNtv46u7p+++plKqWGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the draft plan for maintaining the ARM subarchitectures in a common
tree, as a way to help coordinate the upstream merging of the
arch/arm/{plat,mach}-* changes into Linus' tree.

This was discussed in great length at the Linaro Developer Summit in Budapest
last week where we worked out an initial plan. We are modeling the maintainance
after how the linux-tip tree is used for the x86 architecture, with a set
of developers that have commit access to one tree on kernel.org and
have mutual trust in one another. Nicolas Pitre and me are funded
by Linaro to do the bulk of the work, while Thomas Gleixner will help
us part-time with his long time architecture maintainance experience.
Despite the funding by Linaro, this is not a Linaro project and all
ARM subarchitectures are welcome to go through our tree.

Russell King's role as ARM maintainer is of course unchanged by this, but
he has the same commit access to the new tree as the other maintainers and
is welcome to work in the same tree. We are also open to nominations for
further people outside of Linaro to join us as committers. Marc Zyngier from
ARM ltd is one of the candidates that has been suggested and I would also
like to see someone from Google. We have to find the right balance with the
number of committers so we get all the work done without stepping on each
other's toes.

Our tree will be strictly organized in topic brances so we can feed them
upstream in the bitesized chunks that Linus likes. The master branch
is an integration branch that pulls all other branches that are scheduled
for the next merge window and itself gets integrated into linux-next.

We will probably not be fully functional during the 2.6.40 merge window,
but we are trying our best to be useful. For 2.6.41, my hope is that
we can merge the bulk of the ARM subarchitecture changes through this
tree. Once Linus is happy with the way that the process works, we can
mandate that all ARM subarchitecture changes go through our tree, until
then it stays voluntary.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

---

Maintainers: If you are happy with the layout of the process,
please ack this patch, otherwise please comment.

diff --git a/MAINTAINERS b/MAINTAINERS
index 8fce5e6..942d052 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -630,6 +630,17 @@ S:	Maintained
 F:	drivers/amba/
 F:	include/linux/amba/bus.h
 
+ARM SUBARCHITECTURES
+M:	Arnd Bergmann <arnd@arndb.de>
+M:	Nicolas Pitre <nico@fluxnic.net>
+M:	Thomas Gleixner <tglx@linutronix.de>
+M:	arm@kernel.org
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	MAINTAINED
+F:	arch/arm/mach-*/
+F:	arch/arm/plat-*/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-subarch.git
+
 ARM/ADI ROADRUNNER MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
