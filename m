Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab2BWDzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 22:55:55 -0500
Received: from gherkin.frus.com ([192.158.254.49]:53728 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab2BWDzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 22:55:54 -0500
Date: Wed, 22 Feb 2012 21:55:51 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: "Ted Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 3.3.0-rcX: kjournald
Message-ID: <20120223035551.GA2033@gherkin.frus.com>
References: <20120221054159.GA1919@gherkin.frus.com> <20120221124240.GB5134@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221124240.GB5134@thunk.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 07:42:40AM -0500, Ted Ts'o wrote:
> On Mon, Feb 20, 2012 at 11:41:59PM -0600, Bob Tracy wrote:
> > I'm not sure if I caught a complete instance of this in "syslog", but
> > here's what I've been seeing with 3.3.0-rc[1-3] kernels.  Shortly after
> > booting multi-user, logging in, and attempting a package build, the
> > "fun" starts: the following message scrolls repeatedly (possibly with
> > different details) across the console.  To date, I've had to hit the
> > reset switch to recover, which is why I'm not sure whether I caught a
> > complete syslog entry.
> 
> Hmm..  I've taken a quick look at fs/jbd/commit.c, and I don't see
> anything obvious.  Can you try compiling with LOCKDEP compiled and see
> if you can reproduce it, so we can see what spin lock is being held?

Was waiting for more specific instructions with respect to kernel config
options and how to use LOCKDEP (not familiar with it), and decided to
give 3.3.0-rc4 a try in the meantime.  Did NOT see the kjournald issue.

I guess I'll label this a "watch" item for now, unless something that
changed between -rc3 and -rc4 can be identified as the probable fix.

Thanks.
--Bob
