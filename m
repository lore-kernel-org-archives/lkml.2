Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab1FGHVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 03:21:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41665 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751055Ab1FGHVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 03:21:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/lv55CkNzlNxeas5IXlJvVk17RmGSJOmZHVNfoQm
	pQSMlc0uY0n2bJ
Subject: Re: Linux 3.0-rc2
From: Mike Galbraith <efault@gmx.de>
To: Tarkan Erimer <tarkan@turknetserver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Alessandro Suardi <alessandro.suardi@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4DEDCCFF.10801@turknetserver.com>
References: <BANLkTinrbh7Xi27an3uY7pDWrNKhJRYmEA@mail.gmail.com>
	 <BANLkTik-xtEnf8Bxz3PmP6H+YYSDXe1adw@mail.gmail.com>
	 <BANLkTim1ms9ND6evpDVPFRrJBNffMr4KNg@mail.gmail.com>
	 <alpine.DEB.2.02.1106061308590.25491@asgard.lang.hm>
	 <81e5df54-4987-40ba-9333-79665efda719@email.android.com>
	 <4DEDCCFF.10801@turknetserver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 09:21:46 +0200
Message-ID: <1307431306.9428.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 10:02 +0300, Tarkan Erimer wrote:
> On 06/07/2011 09:22 AM, Linus Torvalds wrote:
> > I suspect not a lot of people actually use the tarballs these days. 
> > It's just much more convenient to get the tree with git. 
> 
> 
> I always use tarballs instead of git. Because; I have several Linux 
> boxes and just one time I download the kernel tarball then spreading it 
> with scp to other Linux boxes easily. Otherwise, I have to prepare a 
> tarball by myself to distribute it which is a time waste and 
> unpractical. Also, getting the whole 700-800 MB of kernel tree with git 
> is not very Internet bandwidth (Consider that in some ISPs and 
> countries, Internet usage is limited by monthly quotas.) friendly.

My connection is crappy 400 kbit/s, but I use git easily.  I set up a
git server, pull upstream daily, and all my boxen can then pull whatever
mainline/stable branch on local network.  Initial clone hurts, but daily
pulls don't.

	-Mike

