Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2BZOYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 09:24:08 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:1395 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561Ab2BZOYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 09:24:05 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host q1QENfvr015817
Subject: Re: Can we move device drivers into user-space?
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Richard Yao <ryao@cs.stonybrook.edu>, Bobby Powers <bobbypowers@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Sun, 26 Feb 2012 15:23:42 +0100
In-Reply-To: <CABDyM6R72WW6YnpNs+EQktaXN_Z_7cxPmABv7ojoLGbmS=+23w@mail.gmail.com>
References: <20120224191535.GA4505@polaris.bitmath.org>
	 <20120224192643.GB24120@kroah.com>
	 <20120224201027.GA4859@polaris.bitmath.org>
	 <20120224201655.GA5994@kroah.com>
	 <20120224203715.GA4995@polaris.bitmath.org>
	 <20120224205651.GA13333@kroah.com>
	 <20120224212238.GA5178@polaris.bitmath.org>
	 <20120224213027.GB15735@thunk.org>
	 <20120224221459.GA5254@polaris.bitmath.org>
	 <CAArOQ2WCXDf2ymxihFdjKhBFMVhtoupVRB97_LsEky4HAGq0hA@mail.gmail.com>
	 <20120226104701.GA18152@polaris.bitmath.org>
	 <CABDyM6R72WW6YnpNs+EQktaXN_Z_7cxPmABv7ojoLGbmS=+23w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1330266224.616.48.camel@thorin>
Mime-Version: 1.0
X-DCC--Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Son, 2012-02-26 at 07:26 -0500, Richard Yao wrote:
> On Sun, Feb 26, 2012 at 5:47 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
[...]
> > changed, is unimportant. Maybe code, like so many other things,
> > arranges itself in a scale-free critical fashion, which would forever

"Code arranges" not itself, but people arrange code the best they see
fit.

> > warrant a monolithic approach. Maybe it would even make sense to have

And the Linux kernel is BTW not really that monolitic in the spirit of
the definition of Tanenbaums book. It's just the category that sucks the
least there.

> > userspace join the same tree as well. There is however a frofoundly
> > political aspect here, which cannot be expressed in terms of
> > code. Also, in practise, breaking things down into manageable chunks
> > is usually a good idea in the end.

Yes, everybody learns that in the first lecture on programming. Please
sent patches to make actually things better and not just talk. Thank
you.

> I do not see what prevents an in-kernel context switch into a ring 3
> context with a different process address space. Is it necessary to
> remove the code from the kernel tree before someone can do this?

No, and that's the real problem here: Everybody who might think it's a
good idea may please implement - and thus propose - something concrete,
try it out and comeback with experience and performance numbers - and
not just try to come up with some theory and other misleading points
(what political aspect?!) and ideas what others should do and why it
might be better.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

