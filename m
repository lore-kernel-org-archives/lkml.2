Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab0DAGGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 02:06:43 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41748 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752843Ab0DAGGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 02:06:36 -0400
Date: Thu, 1 Apr 2010 08:06:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Cyril Hrubis <metan@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [regression] 2.6.34-rc1 to -rc3 on zaurus: no longer boots
Message-ID: <20100401060624.GA1329@ucw.cz>
References: <20100313122754.GD2192@elf.ucw.cz> <20100315102830.GA10288@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315102830.GA10288@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I tried compiling 2.6.34-rc1, and it does not boot :-(. It does not
> > seem to even reset the framebuffer (I'm using kexec -- so it stays
> > stuck on on previous screen).

Tried again with -rc2 and -rc3, and neither boots :-(. I did not have
time to set up serial console, yet :-(. Any ideas?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
