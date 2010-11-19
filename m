Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0KSPOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:14:42 -0500
Received: from smtp5.freeserve.com ([193.252.22.128]:15577 "EHLO
	smtp5.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab0KSPOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:14:40 -0500
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 10:14:40 EST
X-ME-UUID: 20101119150639759.B954C1C000A1@mwinf3411.me.freeserve.com
Date: Fri, 19 Nov 2010 15:06:32 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #20172] 2.6.36-rc7 boot stalls unless nolapic_timer -
 Lenovo S12
Message-ID: <20101119150632.23e4b4af@boulder.homenet>
In-Reply-To: <t78YtCSuOqN.A.L-G.r4b5MB@chimera>
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>
	<t78YtCSuOqN.A.L-G.r4b5MB@chimera>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 00:53:35 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.35 and 2.6.36.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.35 and 2.6.36.  Please verify if it still
> should be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20172
> Subject		: 2.6.36-rc7 boot stalls unless nolapic_timer
> - Lenovo S12 Submitter	: Chris Vine
> <chris@cvine.freeserve.co.uk> Date		: 2010-10-10 12:59
> (40 days old) Message-ID	:
> <<20101010135912.76eb61b7@boulder.homenet>> References	:
> http://marc.info/?l=linux-kernel&m=128671620721712&w=2

This bug is still present in 2.6.37-rc2, but (as the original reporter)
I now doubt it should be classified as a regression.  It looked as if
it was a regression because in the 2.6.35 kernel (the first kernel to
include intel idle), intel idle was available as a kernel module and
that module never in fact loaded on my hardware and so never caused a
hang. In 2.6.36 onwards, intel idle is only available directly compiled
into the kernel and that is when the hang became apparent: subsequent
testing shows that the hang also occurs with 2.6.35 if intel idle is
compiled in rather than as a module.

So it is a bug, which is still present, but not necessarily a
regression.

Chris


