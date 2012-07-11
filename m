Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2GKKn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:43:59 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:58000 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab2GKKn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:43:58 -0400
Date: Wed, 11 Jul 2012 13:43:55 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: valdis.kletnieks@vt.edu
cc: Dave Airlie <airlied@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: 3.5-rc5: radeon acceleration regression on Transmeta system
In-Reply-To: <60495.1341959530@turing-police.cc.vt.edu>
Message-ID: <alpine.SOC.1.00.1207111340360.12880@math.ut.ee>
References: <alpine.SOC.1.00.1207050956300.515@math.ut.ee> <CAPM=9tyo69+8QTCKMDCOTzWT2gR+uXkynOny85PaQ_nCYNMGAg@mail.gmail.com> <alpine.SOC.1.00.1207052224340.19147@math.ut.ee>            <alpine.SOC.1.00.1207090051120.3699@math.ut.ee>
 <60495.1341959530@turing-police.cc.vt.edu>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It's actually more complicated than that. Old kernel images started
> > misbehaving from around 2.6.35-rc5 and any kernel older than that was
> > OK. When I recompiled the older kernels with squeeze gcc (migh have been
> > lenny gcc before, or different answers to make oldconfig), anything from
> > current git down to 2.6.33 is broken with radeon.modeset=1 and works (I
> 
> What releases of GCC were those?  I'm chasing an issue where compiling
> with 4.7.[01] breaks but 4.6.2 is OK, wondering if we're chasing the same thing.

I do not remember when I upgraded from lenny to squeeze. It the previous 
gcc was lenny's, it was gcc version 4.3.2 (Debian 4.3.2-1.1). The gcc in 
current stable (squeeze) is gcc version 4.4.5 (Debian 4.4.5-8). Since 
the old laptop is somewhat slow for following unstable, I have not tried 
any newer gcc version on that machine, and it has been compiling its own 
kernels for stress-testing purposes.

So it's probably not related to gcc 4.6->4.7 changes.

-- 
Meelis Roos (mroos@linux.ee)
