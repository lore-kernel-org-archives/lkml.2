Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab0LCThK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 14:37:10 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41810 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750916Ab0LCThH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 14:37:07 -0500
Date: Fri, 3 Dec 2010 20:36:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jason Vas Dias <jason.vas.dias@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: per-chroot clock module ?
Message-ID: <20101203193658.GB2371@ucw.cz>
References: <201011271821.35039.jason.vas.dias@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011271821.35039.jason.vas.dias@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'd really like to be able to set a distinct "clock" for a specific chroot environment, 
> such that the super-user could call :
>    const char *my_chroot_directory = "/some_chroot";
>    struct stat st;
>    if(stat( my_chroot_directory, &st) ==0)
>          sys_clock_settime ((clockid_t) st.st_inode,  (struct timespec *)tp)
>    ( from glibc )


See subterfugue.net... it can do this.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
