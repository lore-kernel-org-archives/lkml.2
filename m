Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab2BZWDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 17:03:10 -0500
Received: from edge2.cs.stonybrook.edu ([130.245.9.211]:54868 "EHLO
	edge2.cs.stonybrook.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2BZWDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 17:03:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ryao@cs.stonybrook.edu designates 10.50.89.232 as permitted sender) smtp.mail=ryao@cs.stonybrook.edu
MIME-Version: 1.0
In-Reply-To: <10de0ef9fb5d44c08669191e12343a97@HUBCAS2.cs.stonybrook.edu>
References: <20120224203715.GA4995@polaris.bitmath.org>
	<20120224205651.GA13333@kroah.com>
	<20120224212238.GA5178@polaris.bitmath.org>
	<20120224213027.GB15735@thunk.org>
	<20120224221459.GA5254@polaris.bitmath.org>
	<CAArOQ2WCXDf2ymxihFdjKhBFMVhtoupVRB97_LsEky4HAGq0hA@mail.gmail.com>
	<20120226104701.GA18152@polaris.bitmath.org>
	<CABDyM6R72WW6YnpNs+EQktaXN_Z_7cxPmABv7ojoLGbmS=+23w@mail.gmail.com>
	<365b85cee33d4f1aadc31336663de21c@HUBCAS2.cs.stonybrook.edu>
	<CABDyM6Q309HeTv3PMc6QaJqGg0MWGV3y2KdeBEKENbD-cCV0Sg@mail.gmail.com>
	<09a5cca9cffb4300843f682be529e8ca@HUBCAS2.cs.stonybrook.edu>
	<CABDyM6Qzm3nfQDD1mHcQ58JUVECaPdukTB+b5-WxP=iqoONF4w@mail.gmail.com>
	<10de0ef9fb5d44c08669191e12343a97@HUBCAS2.cs.stonybrook.edu>
Date: Sun, 26 Feb 2012 17:03:06 -0500
Message-ID: <CABDyM6SaRKg+gVvyFCyZkTBtCbkFtXxZVrX=xe4U7Xp3XMV9XA@mail.gmail.com>
Subject: Re: Can we move device drivers into user-space?
From: Richard Yao <ryao@cs.stonybrook.edu>
To: Theodore Tso <tytso@mit.edu>
CC: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Henrik Rydberg <rydberg@euromail.se>,
        Bobby Powers <bobbypowers@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [209.85.210.174]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is that there are a huge number of crackpots out there, and Linux is popular enough that many of them tend to gravitate to the LKML.    If they want to brainstorm, that's fine; but don't expect senior kernel developers to necessarily pay a lot of attention.

I think it is nice for people to be interested in kernel design and
even if they have bad ideas, letting them discuss their ideas
generally gives them the opportunity to learn why they are bad, which
could generate good ideas in the process. microkernel designs are
nice, but Linux is not the right basis for one.

With that said, I suggest you refrain from being so quick to judge. It
is a slippery slope that can lead you to consider anyone absent from a
mental whitelist to be "a crackpot". It also causes problems when you
misidentify someone because he made an attempt to help less
knowledgeable people learn, rather than telling them with his vision
of how things work. This can happen whenever you meet new people who
would have been on your list had you known them better.

Yours truly,
Richard Yao
