Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab2KEXBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:01:06 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:59504 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab2KEXBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:01:04 -0500
Date: Mon, 5 Nov 2012 18:00:51 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Richard Hipp <drh@sqlite.org>
Cc: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        Pavel Machek <pavel@ucw.cz>, david@lang.hm,
        Nico Williams <nico@cryptonector.com>,
        ????????? Yang Su Li <suli@cs.wisc.edu>, linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
Message-ID: <20121105230051.GA31623@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Richard Hipp <drh@sqlite.org>,
	General Discussion of SQLite Database <sqlite-users@sqlite.org>,
	Pavel Machek <pavel@ucw.cz>, david@lang.hm,
	Nico Williams <nico@cryptonector.com>,
	????????? Yang Su Li <suli@cs.wisc.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
References: <alpine.DEB.2.02.1210241748180.8519@asgard.lang.hm>
 <CAK3OfOjtH9qVghb6+33HSb8+dPZVexLC9Z5XO1KKvjoTYiYp4A@mail.gmail.com>
 <20121025060231.GC9860@thunk.org>
 <alpine.DEB.2.02.1210242331060.31862@asgard.lang.hm>
 <20121025140327.GB13562@thunk.org>
 <alpine.DEB.2.02.1210251048280.8519@asgard.lang.hm>
 <20121025182948.GB16257@thunk.org>
 <20121105200348.GB15821@xo-6d-61-c0.localdomain>
 <20121105220440.GB25378@thunk.org>
 <CALwJ=Mx-uEFLXK2wywekk=0dwrwVFb68wocnH9bjXJmHRsJx3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALwJ=Mx-uEFLXK2wywekk=0dwrwVFb68wocnH9bjXJmHRsJx3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 05:37:02PM -0500, Richard Hipp wrote:
> 
> Per the docs:  "Only the superuser or a process possessing the
> CAP_SYS_RESOURCE capability can set or clear this attribute."  That
> prevents most applications that run SQLite from being able to take
> advantage of this, since most such applications lack elevated privileges.

If this feature would prove useful to sqllite, that's something we
could address.  I could image making this available to processes that
belong to a specific group that would be specified in the superblock
or as a mount option.  (We already have something like that which
allows a specific uid or gid to use the reserved space in the
superblock.)

							- Ted
