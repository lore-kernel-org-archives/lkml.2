Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab0KXOq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:46:29 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38206 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751342Ab0KXOq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:46:28 -0500
Date: Tue, 23 Nov 2010 18:24:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kyle Moffett <kyle@moffetthome.net>, Marcus Meissner <meissner@suse.de>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@osdl.org, hpa@zytor.com, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101123172437.GB8412@ucw.cz>
References: <20101116104600.GA24015@suse.de>
 <AANLkTi=F1vbwpOzyN9o0nuRtsEUTQx2j3==kLu9j7Ccb@mail.gmail.com>
 <20101118073126.GB32621@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118073126.GB32621@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >   (2) Most of the arguments about introducing "uncertainty" into the
> > hacking process are specious as well. [...]
> 
> It is only specious if you ignore the arguments i made in the previous
> discussion. One argument i made was:

Well, but it has downsides, too.

If I know school server is vulnerable, I can get admin to fix it... if
I can see dmesg without being root, I can help with problems. I have
done both before...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
