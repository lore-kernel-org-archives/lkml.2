Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab2BZPGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 10:06:06 -0500
Received: from edge1.cs.stonybrook.edu ([130.245.9.210]:36982 "EHLO
	edge1.cs.stonybrook.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2BZPGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 10:06:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ryao@cs.stonybrook.edu designates 10.43.49.201 as permitted sender) smtp.mail=ryao@cs.stonybrook.edu
MIME-Version: 1.0
In-Reply-To: <365b85cee33d4f1aadc31336663de21c@HUBCAS2.cs.stonybrook.edu>
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
	<365b85cee33d4f1aadc31336663de21c@HUBCAS2.cs.stonybrook.edu>
Date: Sun, 26 Feb 2012 10:05:59 -0500
Message-ID: <CABDyM6Q309HeTv3PMc6QaJqGg0MWGV3y2KdeBEKENbD-cCV0Sg@mail.gmail.com>
Subject: Re: Can we move device drivers into user-space?
From: Richard Yao <ryao@cs.stonybrook.edu>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
CC: Henrik Rydberg <rydberg@euromail.se>, Bobby Powers <bobbypowers@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Originating-IP: [209.85.210.174]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I do not see what prevents an in-kernel context switch into a ring 3
>> context with a different process address space. Is it necessary to
>> remove the code from the kernel tree before someone can do this?
>
> No, and that's the real problem here: Everybody who might think it's a
> good idea may please implement - and thus propose - something concrete,
> try it out and comeback with experience and performance numbers - and
> not just try to come up with some theory and other misleading points
> (what political aspect?!) and ideas what others should do and why it
> might be better.

It seems counterproductive to tell people to produce results without
doing the brainstorming that such results require.

If such discussion is not welcome here, then the FreeBSD project has a
similar kernel design. Perhaps it would be more productive for those
interested in this to brainstorm on their mailing list. If anything
materializes, it could be for their kernel instead. Nothing is forcing
anyone to do things with Linux.
