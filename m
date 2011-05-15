Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1EOObo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 10:31:44 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:32797 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754038Ab1EOObn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 10:31:43 -0400
Date: Sun, 15 May 2011 16:31:41 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: Re: Zaurus CF tests -- ok
Message-ID: <20110515143141.GA7913@atrey.karlin.mff.cuni.cz>
References: <20110415211822.GB21111@atrey.karlin.mff.cuni.cz> <20110415213817.GC4420@atrey.karlin.mff.cuni.cz> <20110416074134.GA26440@ucw.cz> <201105151426.50230.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105151426.50230.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> Backtrace from QEMU ... I think this is what Cyril observed. But heck, it 
> happens in QEMU too ;-)

Yes, that is pretty much it.

It happens randomly, eg. adding printk() line into kernel code (somewhere in
mmc stack). Or sometimes crashes in the pccard initalization when two cards are
inserted at the boot time.

-- 
metan
