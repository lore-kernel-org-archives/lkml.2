Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab0G2Oa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 10:30:28 -0400
Received: from xenotime.net ([72.52.115.56]:42413 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757340Ab0G2Oa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 10:30:27 -0400
Date: Thu, 29 Jul 2010 07:30:16 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] kconfig: use long options in conf
Message-Id: <20100729073016.ba265b59.rdunlap@xenotime.net>
In-Reply-To: <4C515318.40706@suse.cz>
References: <20100725213808.GA5814@merkur.ravnborg.org>
	<20100725214021.GD5834@merkur.ravnborg.org>
	<4C4EFE80.7050808@suse.cz>
	<20100728203622.GA32086@merkur.ravnborg.org>
	<4C51473A.4000605@suse.cz>
	<20100729093946.GA6725@merkur.ravnborg.org>
	<4C515318.40706@suse.cz>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 12:08:24 +0200 Michal Marek wrote:

> On 29.7.2010 11:39, Sam Ravnborg wrote:
> > I had in mind to deprecate randconfig in favour of allrandconfig
> > to get more consitency in the names.
> > But I failed to document this in the changelog.
> > 
> > I can submit the following as a real patch if you agree.
> 
> To me it seems like a change for the sake of change :), but if you like
> to have the targets named all*config consistenly, I'm OK with it.


Well, there are scripts that know the old name, so if it's just change
for the sake of change, let's not.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
