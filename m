Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0K2Ban (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 20:30:43 -0500
Received: from infernal.debian.net ([87.230.26.131]:52338 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0K2Bam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 20:30:42 -0500
X-Greylist: delayed 2103 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Nov 2010 20:30:42 EST
Date: Mon, 29 Nov 2010 01:55:36 +0100
From: Andreas Bombe <andreas.bombe@mytum.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>, DRI <dri-devel@lists.freedesktop.org>
Subject: Re: [Regression, post-2.6.37-rc2] Unable to start KDE with
 2.6.37-rc3 on Acer Ferrari One
Message-ID: <20101129005535.GA3672@amos.fritz.box>
References: <201011240122.33174.rjw@sisk.pl>
 <201011240157.00726.rjw@sisk.pl>
 <AANLkTinRvXC9qDi9rkg1OeQ9FXrBwVJU0Y=9bUwrv8T4@mail.gmail.com>
 <201011240245.55786.rjw@sisk.pl>
 <AANLkTinQZDauFRy3ttzTWHFV7pFekqrGPk8MD6P++kYB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinQZDauFRy3ttzTWHFV7pFekqrGPk8MD6P++kYB@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 09:02:57PM -0500, Alex Deucher wrote:
> On Tue, Nov 23, 2010 at 8:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, November 24, 2010, Alex Deucher wrote:
> >> Are you sure you've got the right commit?
> >
> > Well, as I said, I reverted that particular commit and things started to work.
> >
> >> That shouldn't change the calculation that's failing at all.  I'd guess it's
> >> probably one of these:
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d33ef52d9db8a36900dd53f2e32db9a521ace259
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f30df2fad0c901e74ac9a52a488a54c69a373a41
> >
> > I don't know.  Perhaps there are some interactions between the two and the
> > reverted one.  I can try reverting these tomorrow if you want me to.
> 
> Can you try just reverting this patch:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d33ef52d9db8a36900dd53f2e32db9a521ace259
> 
> I think the real issue is a bug in the 3D driver (probably a flush at
> the wrong time) that one of these commits exposing.

I ran into the same problem and bisected, commit d33ef52 got the blame.
It's a Radeon HD 4850 in my case, apart from that the problem was
exactly the same.

-- 
Andreas Bombe
