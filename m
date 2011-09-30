Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab1I3Pym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:54:42 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:59612 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab1I3Pyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:54:40 -0400
Date: Fri, 30 Sep 2011 18:54:36 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Please revert "debug: Make CONFIG_EXPERT select
 CONFIG_DEBUG_KERNEL to unhide debug options"
Message-ID: <20110930155436.GD9049@localhost.pp.htv.fi>
References: <20110930134245.GB21474@localhost.pp.htv.fi>
 <20110930150519.GA7980@leaf>
 <20110930152517.GE19053@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110930152517.GE19053@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 05:25:23PM +0200, Frederic Weisbecker wrote:
>...
> All in one I think we chose a wrong way to fix the issue. It's annoying to
> have all the configs that are only visible with CONFIG_EXPERT spread all
> around in random config menu.
> 
> Anything that has "if CONFIG_EXPERT" should probably be moved under the CONFIG_EXPERT
> menu so that it's visible and found right away.

No, it wouldn't be correct to have tons of options from different 
drivers smashed at one place, instead of keeping them at the subsystem 
where they belong.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

