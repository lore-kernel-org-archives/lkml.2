Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab1JCVLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:11:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:53542 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574Ab1JCVLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 17:11:16 -0400
Date: Mon, 3 Oct 2011 23:11:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 3.0.6
In-Reply-To: <20111003203537.GC22113@kroah.com>
Message-ID: <alpine.LFD.2.02.1110032308120.1489@ionos>
References: <20111003203537.GC22113@kroah.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, Greg KH wrote:

> I'm announcing the release of the 3.0.6 kernel.
> 
> There was a build error in the radeon driver of the 3.0.5 kernel, so
> this update is only needed if you have problems building that kernel.
> 
> The updated 3.0.y git tree can be found at (NOTE THE ADDRESS CHANGE):
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

That's missing the branch

 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git 3.0.y

and while I can see the reason to make branches instead of separate
trees, it's a nightmare when you want to get the 3.0.y tags because
git insists on downloading the world and some more :(. It's just a one
time thing, but nevertheless anoying as hell.

Thanks,

	tglx
