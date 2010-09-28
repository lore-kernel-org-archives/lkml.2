Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab0I1TIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 15:08:25 -0400
Received: from lo.gmane.org ([80.91.229.12]:41156 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab0I1TIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 15:08:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [RFC] Online firmware upgrade in non-embedded systems
Date: Tue, 28 Sep 2010 19:45:33 +0100
Message-ID: <dnp9n7-puv.ln1@chipmunk.wormnet.eu>
References: <1285696787.2282.45.camel@achroite.uk.solarflarecom.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Cc: netdev@vger.kernel.org, linux-mtd@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In gmane.linux.kernel Ben Hutchings <bhutchings@solarflare.com> wrote:
> 
> Currently the sfc network driver is optionally combined with an MTD
> driver (CONFIG_SFC_MTD) which exposes all upgradable firmware and
> configuration partitions in flash.  This works nicely in kernels with
> MTD enabled, but since MTD is mainly used in embedded systems with
> on-board flash it is often disabled in distribution kernels and custom
> kernels alike.  This leaves users of sfc unable to upgrade firmware
> without rebuilding the kernel or booting some other distribution.  The
> lack of widespread MTD support is a regular cause of support requests.
> 
----
ac56@proxy0:~$ uname -a
Linux proxy0 2.6.32-5-686 #1 SMP Wed Aug 25 14:28:12 UTC 2010 i686 GNU/Linux
ac56@proxy0:~$ cat /etc/debian_version 
squeeze/sid
ac56@proxy0:~$ grep CONFIG_SFC_MTD /boot/config-2.6.32-5-686 
CONFIG_SFC_MTD=y
ac56@proxy0:~$ grep '^CONFIG_MTD' /boot/config-2.6.32-5-686 | wc
     72      72    1693
----

I tell them "use a real distribution".

Cheers

-- 
Alexander Clouter
.sigmonster says: BOFH excuse #119:
                  evil hackers from Serbia.

