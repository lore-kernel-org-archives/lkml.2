Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab0C0Tvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 15:51:42 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53610 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753864Ab0C0Tvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 15:51:40 -0400
Date: Sat, 27 Mar 2010 20:51:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.34-rc1: regression: ^Z no longer stops sound
Message-ID: <20100327195133.GC2103@elf.ucw.cz>
References: <20100314075831.GA13457@elf.ucw.cz>
 <201003202055.46933.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003202055.46933.maciej.rutecki@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-03-20 20:55:46, Maciej Rutecki wrote:
> On niedziela, 14 marca 2010 o 08:58:31 Pavel Machek wrote:
> > Hi!
> > 
> > In 2.6.33, hitting ^Z stopped mpg123 in a way you'd expect (both on
> > thinkpad and geode notebook).
> > 
> > On 2.6.34-rc1, hit ^Z and sound starts looping.
> > 									Pavel
> > 
> I created a Bugzilla entry at  
> https://bugzilla.kernel.org/show_bug.cgi?id=15590
> for your bug report, please add your address to the CC list in
> there, thanks!

It was fixed by patch in 
"[for 2.6.34][PATCH] ALSA: pcm_lib - fix xrun functionality"
thread. It should already be in sound tree.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
