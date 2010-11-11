Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0KKJ3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:29:11 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:60339 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab0KKJ3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:29:09 -0500
Subject: Re: PROBLEM: first read of /dev/mcelog fails
From: Jon Masters <jonathan@jonmasters.org>
To: andi@firstfloor.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1289385151.3916.554.camel@constitution.bos.jonmasters.org>
References: <1289385151.3916.554.camel@constitution.bos.jonmasters.org>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Thu, 11 Nov 2010 04:29:09 -0500
Message-ID: <1289467749.3916.607.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 05:32 -0500, Jon Masters wrote:

> I recently took some time to look at the daemon side of mcelog. I found
> a few issues with that[0] that I will detail in a separate mail, but I
> am more concerned that in recent kernels, the first read() of the mcelog
> device performed by mcelog after boot always fails. 100% reproducible on
> several machines - mcelog client always bombs out in process() due to
> getting a "no such device" error from the kernel read attempt.
> The /dev/mcelog device exists, but the first read fails.

I am looking into this, time permitting. Can you give me an indication
of the current plans for mcelog support in the kernel? Given that we've
had various discussion recently about EDAC and other error reporting
mechanisms, I would like to know if you plan for mcelog to stick around.

> [0] ignoredev not documented, cache-error-trigger uses $CPUS_AFFECTED
> when it should be $AFFECTED_CPUS, mcelog-client socket is always created
> no matter what the config says (and not deleted on shutdown).

I sent you a separate mail with a pull request containing the first
batch of fixes to this tool (already in the Fedora package).

Jon.


