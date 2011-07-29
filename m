Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1G2T7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 15:59:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35387 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab1G2T7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 15:59:17 -0400
Date: Fri, 29 Jul 2011 21:59:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
Cc: Matthias Schniedermeyer <ms@citd.de>, linux-kernel@vger.kernel.org
Subject: Re: ext3 hacked filesystem (by debian exim4 exploit) available for
 analysis and bugreporting
Message-ID: <20110729195904.GC1720@ucw.cz>
References: <CAPweEDzv+vByC1s2bWRjVQdVLqw4Xf2sUf_CQgVync_YcxtdvQ@mail.gmail.com>
 <20110725134533.GA23781@citd.de>
 <CAPweEDybuOpPVidJWg+rfs8rU8y=xo4d3H=P7XQJh_DiKrF4DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPweEDybuOpPVidJWg+rfs8rU8y=xo4d3H=P7XQJh_DiKrF4DQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-07-25 22:08:24, Luke Kenneth Casson Leighton wrote:
> On Mon, Jul 25, 2011 at 2:45 PM, Matthias Schniedermeyer <ms@citd.de> wrote:
> > On 25.07.2011 13:08, Luke Kenneth Casson Leighton wrote:
> >> folks, hi,
> >>
> >> apart from anything, files which cannot be deleted (and cannot be
> >> detected as "corrupted" by fsck.ext3) is pretty damn serious.
> >
> > You did try lsattr and checked that the files aren't 'immutable'?
> 
>  i didn't! :)  didn't know about (but should have guessed) ext3
> attributes.  they are indeed - thank you matthias.
> 
> root@quietbaby:/mnt/horsebox/tmp3# lsattr *
> ----ia------------- bin3/kill
> ----ia------------- bin3/ps
> ----ia------------- c.pl
> ----ia------------- e.conf
> ----ia------------- sbin3/sysctl
> ----ia------------- usrbin3/uptime
> ----ia------------- usrbin3/tload
> ----ia------------- usrbin3/free
> ----ia------------- usrbin3/top
> ----ia------------- usrbin3/vmstat
> ----ia------------- usrbin3/watch
> ----ia------------- usrbin3/skill
> ----ia------------- usrbin3/pmap
> ----ia------------- usrbin3/pgrep
> ----ia------------- usrbin3/slabtop
> ----ia------------- usrbin3/pwdx
> ----ia------------- usrbin3/snice
> ----ia------------- usrbin3/pkill
> ----ia------------- usrbin3/w
> 
> so - looks like it's not as bad as i thought.

Should ls -l be moddified to show something when file has immutable
(and friends) set?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
