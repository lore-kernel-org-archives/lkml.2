Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0CUUkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:40:41 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48618 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752730Ab0CUUkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:40:39 -0400
Date: Sun, 21 Mar 2010 21:40:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Cyril Hrubis <metan@ucw.cz>, Eric Miao <eric.y.miao@gmail.com>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com,
       zaurus-devel@www.linuxtogo.org
Subject: Re: bit errors on spitz
Message-ID: <20100321204032.GL1933@elf.ucw.cz>
References: <20100305212708.GC21773@elf.ucw.cz>
 <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>
 <20100308072858.GA29939@atrey.karlin.mff.cuni.cz>
 <20100308082530.GA1982@atrey.karlin.mff.cuni.cz>
 <1268048916.6477.9.camel@utx.utx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268048916.6477.9.camel@utx.utx.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-03-08 12:48:36, Stanislav Brabec wrote:
> Cyril Hrubis wrote:
> 
> > Well I've seen empty lines when editing file with vim
> 
> And I have seen:
> 
> - Unreproducible SIGSEGV of gcc (while Wi-Fi connection over CF card was
>   running).
> - Unreproducible SIGSEGV of opkg (downloading via Wi-Fi connection over
>   CF card).
> - Unreproducible SIGSEGV of rm (called from find command launched via
>   ssh, networking via Wi-Fi connection over CF card).
>   (Hint: Tasks above are HDD-intensive.)
> - Lost blocks while copying from CF to SD.
> - Lost blocks while copying from HDD to SD.
> - Lost blocks while copying from CF to USB flash stick.
> - And I see display noise while CF Wi-Fi card is active.
> 
> These problems appear in all kernels, at least since 2.6.26.
> 
> There is no note in the syslog.

Interesting, I get memory corruption leading to strange
behaviour. Sometimes echo 3 > /proc/sys/vm/drop_caches helps...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
