Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761388Ab2FICDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 22:03:43 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60385 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2FICDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 22:03:41 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 8 Jun 2012 19:03:19 -0700
X-Google-Sender-Auth: htBsLYlUVrUEFzt_lqaxsLNNyvQ
Message-ID: <CA+55aFz0sGcCw2W2r4z673_xhe0Ej94Yqi_VZDtY1Qzovz4qfA@mail.gmail.com>
Subject: Linux 3.5-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, it's been only 6 days, but as noted earlier I'm going to be
traveling starting tomorrow, and I wanted to make the -rc2 release
before I left.

I'll have internet access, but looking at my schedule I probably won't
have much time, so you might as well consider me MIA for a week. If
it's not really critical, don't bother asking me to pull, in other
words. Think of it as one of those weeks when I try to be hardnosed
about things, and get bitchy when people send me irrelevant small
stuff that isn't some major oops-fix.

That said, I think -rc2 is in fairly good shape, and I've been trying
to fairly aggressively revert things that caused problems (and
sometimes things that were only *suspected* to be the cause of
problems).

We have the usual assortment of fixes: drivers (gpu, i2c, acpi,
clocksource), architectures (mostly x86 perf, but some trivial powerpc
and parsic stuff), filesystems (fuse, cifs, ext4, ubifs) along with VM
updates and some documentation updates. And timer, irq and scheduler
fixes.

Go forth and test,
                      Linus
