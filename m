Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2B0LSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 06:18:10 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:1230 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335Ab2B0LSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 06:18:07 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host q1RBHnBC002693
Subject: Re: Can we move device drivers into user-space?
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Richard Yao <ryao@cs.stonybrook.edu>
Cc: Theodore Tso <tytso@mit.edu>, Henrik Rydberg <rydberg@euromail.se>,
        Bobby Powers <bobbypowers@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Mon, 27 Feb 2012 12:17:50 +0100
In-Reply-To: <CABDyM6SaRKg+gVvyFCyZkTBtCbkFtXxZVrX=xe4U7Xp3XMV9XA@mail.gmail.com>
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
	 <CABDyM6SaRKg+gVvyFCyZkTBtCbkFtXxZVrX=xe4U7Xp3XMV9XA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1330341472.17330.19.camel@thorin>
Mime-Version: 1.0
X-DCC-URT-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Son, 2012-02-26 at 17:03 -0500, Richard Yao wrote:
[...]
> I think it is nice for people to be interested in kernel design and
> even if they have bad ideas, letting them discuss their ideas
> generally gives them the opportunity to learn why they are bad, which
> could generate good ideas in the process.

Part of the learning experience is (or should be IMHO) to - at least -
try it out in someway at some point and not only "discuss" it or throw
ideas around.
And that is: look for one target like a char driver or a filesystem or
what ever one likes or seems fit and try to produce a somewhat working
prototype.
The performance point is probably valid but not every driver is a high
performance issue.
As for "filesystems", there is already FUSE around BTW. And IIRC there
were similar efforts for block and/or char drivers.

And of course, the "try it out" means primarily the OP - see the other
mail.

>                                           microkernel designs are
> nice, but Linux is not the right basis for one.

Yes, that's the reason that everyone uses a microkernel today. SCNR ....
And Mach got at times so fat so that people considered something else. 

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

