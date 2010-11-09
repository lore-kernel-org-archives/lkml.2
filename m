Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab0KIP5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:57:03 -0500
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:44835 "EHLO
	homiemail-a1.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751069Ab0KIP5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:57:01 -0500
Subject: Re: [ANNOUNCE] fbdev git tree.
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-fbdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        James Simmons <jsimmons@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
In-Reply-To: <20101109093204.GB21086@linux-sh.org>
References: <20101109093204.GB21086@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 12:56:48 -0300
Message-ID: <1289318208.2260.9.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 18:32 +0900, Paul Mundt wrote:
> As I find myself spending more time reviewing and merging fbdev patches
> lately, and in an effort to offload some of the pressure on -mm, I've
> opted to start a git tree to start collecting and merging fbdev changes.
> 
> I plan to get a patchwork queue established for the list as well so that
> things don't fall through the cracks (the link will be posted once it's
> been established). People will be able to see the status of their patches
> this way, rather than wondering whether things are being picked up,
> overlooked, or forced through an alternate merge strategy (We have had
> reasonable success with this with the SH tree, so here's hoping that the
> same approach will work well here, too).
> 
> I've already made a note about this to akpm off-list, so fbdev patches
> that pop up outside of the regular channels that I may be unaware of
> should still have a reasonable chance of being intercepted and rerouted
> (although the mmotm is rather devoid of drivers/video churn at the
> moment).
> 
> I'll be combing through the list archives to see if there is anything
> glaringly outstanding (the HDMI/EDID work comes to mind) and working on
> getting the oustanding issues there resolved. If anyone has any
> outstanding patches that have fallen through the cracks, now would be a
> good time to provide pointers!
> 
> Given the point that we're at with .38 bits now and a cursory look at
> -next shows that there's already quite a bit of drivers/video churn
> coming in from git trees. It will likely take a few cycles to get people
> used to the idea of there being an active fbdev tree to merge through,
> but with any luck it will be a fairly natural transition. I'll be
> contacting and working with git tree owners separately so there aren't
> any surprises.
> 
> The tree can be found at:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git
> 

Could this be added to the MAINTAINERS file?

 FRAMEBUFFER LAYER
 L:     linux-fbdev@vger.kernel.org
 W:     http://linux-fbdev.sourceforge.net/
+T:
git://git.kernel.org/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git
 S:     Orphan
 F:     Documentation/fb/
 F:     drivers/video/fb*

> Stephen, if you could add this with the master branch to -next, it would
> be appreciated. For the moment I expect most of the patches to follow a
> fairly linear line of development, but there may be cause for topic
> branches as new (or contested) patch sets arise.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


