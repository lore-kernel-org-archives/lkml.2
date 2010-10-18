Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0JRHlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 03:41:44 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:57482 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab0JRHlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 03:41:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19643.64049.949858.105680@pilspetsen.it.uu.se>
Date: Mon, 18 Oct 2010 09:41:37 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [Bug #19072] [2.6.36-rc regression] occasional complete system hangs on sparc64 SMP
In-Reply-To: <7N-qxsaxKCN.A.i4C.yk1uMB@chimera>
References: <TP5BfCZNRXD.A._8.uj1uMB@chimera>
	<7N-qxsaxKCN.A.i4C.yk1uMB@chimera>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Oct 2010 22:21:42 +0200 (CEST), Rafael J. Wysocki <rjw@sisk.pl> wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D19072
> Subject		: [2.6.36-rc regression] occasional complete system hangs on sparc=
> 64 SMP
> Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> Date		: 2010-09-23 17:02 (25 days old)
> Message-ID	: <<19611.34846.813757.309183@pilspetsen.it.uu.se>>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D128526136531048&w=3D2

I've not been able to reproduce it yet with 2.6.36-rc7, but there's
been no known recent bugfix in this area so whether the bug is fixed
or not is unknown.  If I've not been able to reproduce it on -rc7 or
-rc8 after next weekend we could close the bug.
