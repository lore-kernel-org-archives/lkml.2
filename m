Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2BBCgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:36:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:33844 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab2BBCgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:36:38 -0500
Message-ID: <1328150174.28487.100.camel@pasglop>
Subject: [RFC] Removing support for legacy iSeries
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linuxppc-dev@lists.ozlabs.org
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Paul Mackerras <pmac@au1.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 02 Feb 2012 13:36:14 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I (and Stephen) believe the time has come that we get rid of the
legacy iSeries support in the kernel....

Is there any objection ? Do we have any user left ?

The hypervisor on these is really nasty, and removing support for it
would allow us to clean up quite a bit of code path including low level
& asm ones from iSeries special cases.

Also it's becoming increasingly hard for me to test that we are still
capable of booting these.

I will keep it if we have users but since distros don't support it
anymore (and haven't for a while now) I am pretty keen.

Any objection ?

Cheers,
Ben.


