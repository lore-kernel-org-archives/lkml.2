Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1D1UhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:37:04 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44654 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753252Ab1D1UhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:37:02 -0400
Date: Thu, 28 Apr 2011 22:36:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Martin Jansa <martin.jansa@gmail.com>
Cc: Zaurus PDA developers list <zaurus-devel@www.linuxtogo.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, thommycheck@gmail.com,
        Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
        kernel list <linux-kernel@vger.kernel.org>, lenz@cs.wisc.edu,
        rpurdie@rpsys.net, eric.y.miao@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Zaurus-devel] 2.6.39-rc5 on zaurus: works
Message-ID: <20110428203659.GA22663@elf.ucw.cz>
References: <20110408062646.GA1472@ucw.cz>
 <201104080931.11202.marek.vasut@gmail.com>
 <20110408082827.GD3180@jama.jama.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408082827.GD3180@jama.jama.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Build fix is below. Maybe it is pending in the trees somewhere
> > > already...
> > 
> > Fix is already there, it was broken by a patch from someone recently. Thanks 
> > though
> > > 
> > > Boot stops just after mounting root filesystem; cursor stops
> > > flashing. (Any idea what goes on there?)
> > 
> > No idea, it works for me and doesn't hang ;-)
> 
> it works here too with rev 6221f222c0ebf1acdf7abcf927178f40e1a65e2a

I had problems mounting filesystems; good news is that in 2.6.39-rc5
these are fixed.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
