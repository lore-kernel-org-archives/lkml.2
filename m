Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3AICpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 21:45:30 -0500
Received: from magic.merlins.org ([209.81.13.136]:40249 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab3AICp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 21:45:29 -0500
Date: Tue, 8 Jan 2013 18:45:28 -0800
From: Marc MERLIN <marc@merlins.org>
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Supporting SYSRQ on broken laptops like the thinkpad T530
Message-ID: <20130109024528.GR2044@merlins.org>
References: <20130108230954.GN2044@merlins.org> <20130109023643.GA7066@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130109023643.GA7066@mobil.systemanalysen.net>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-Operating-System: Proudly running Linux 3.1.5-core2-volpreempt-noide-hm64-20111218/Debian squeeze/sid
X-Mailer: Some Outlooks can't quote properly without this header
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: marc@merlins.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 03:36:44AM +0100, Roland Eggner wrote:
> On 2013-01-08 Tuesday at 15:09 -0800 Marc MERLIN wrote:
> > In its infinite wisdom, lenovo has removed the sysrq key on the latest
> > thinkpads, and replaced it with a stupid ALT+FN+S key combination, which
> > doesn't really work for doing sysrq from the console (nor do I know how the
> > genius who did that intended for SYSRQ-S to work).
> > http://forums.lenovo.com/t5/T400-T500-and-newer-T-series/T430-s-T530-Where-are-the-shortcut-function-keys-break-Pause-etc/ta-p/781749
> > 
> > I realize that one solution is to throw my laptop window at a suitable high
> > floorand replace it with one from a vendor that doesn't randomly remove keys
> > from the keyboard.
> > That said, I was wondering if there were other solutions, especially
> > considering that thinkpads used to be the better linux laptops.
> 
> My Dell “Precision M4500” notebook suffers similar (same?) problem.  So far 
> I could not find a solution better than this:  e.g. Alt-Fn-SysRq-s
> 
> press and hold Alt
> press and hold Fn
> press and leave F10|SysRq
> leave Fn
> press and leave s
> leave Alt

Holy crap. That works for me too. If only lenovo could have been bothered to
document it properly. It's still a pitty to type and remmember the exact
hold and release key sequences, but it's better than nothing.

Thanks much.

> Several months ago a LKML user claimed, his cat had managed to press 
> Alt-Fn-SysRq-c on his Dell Latitude notebook with similar keyboard, and provided 
> photos showing the kernel crash message ;)

Yeah, but my cat is not nearly smart enough for that :)

Thanks for your help again,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
