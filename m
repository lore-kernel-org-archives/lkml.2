Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0FGSG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:06:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044Ab0FGSGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:06:55 -0400
Date: Mon, 7 Jun 2010 11:00:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
In-Reply-To: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie>
Message-ID: <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jun 2010, Dave Airlie wrote:
> 
> 3 regressions fixes, one radeon loading on IGP, one i865 loading, one and 
> an evergreen userspace interaction workaround.

This is:

	 26 files changed, 372 insertions(+), 66 deletions(-)

and there are apparently several reports of known problems (the problem 
with modesetting) that isn't even addressed.

See my -rc2 announcement. I absolutely do NOT want any new code. I want 
regression fixes, fixes for security issues, and fixes for oopses. Nothing 
else. I'm going to be hardassed about this, because quite frankly, if I'm 
not, people will just continue with the same-old, same-old, and send me 
random stuff without thinking hard about it.

So please. Just make me a tree that has regression fixes _only_. I'm not 
AT ALL interested in "it is useful to report the gpu temp". If it was so 
useful, and if it was ready before the merge window, it should hav gone in 
then. That clearly wasn't the case, so it's not going in now either.

		Linus
