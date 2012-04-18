Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab2DRJb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:31:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50242 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab2DRJb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:31:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sven Joachim <svenjoac@gmx.de>, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: kernel panic after suspend/resume
Date: Wed, 18 Apr 2012 11:36:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFzsjpJt09b6e4NA0T50M3w0xtASSYXz_=UWVDqKRywo=A@mail.gmail.com> <201204172321.41095.rjw@sisk.pl> <87hawhtpo9.fsf@turtle.gmx.de>
In-Reply-To: <87hawhtpo9.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201204181136.05521.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 18, 2012, Sven Joachim wrote:
> On 2012-04-17 23:21 +0200, Rafael J. Wysocki wrote:
> 
> > Well, commit fa4da365bc7772c kind of looks like it might be the source of
> > this trouble.  Sven, can you try to revert it, please?
> 
> This seems to do the trick, thanks.

OK, thanks.

Suresh, your commit fa4da365bc7772c "clockevents: tTack broadcast device mode
change in tick_broadcast_switch_to_oneshot()" introduced a system resume
regression for Sven.  Can you have a look at this, please?

Rafael
