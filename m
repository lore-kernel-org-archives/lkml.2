Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab2BZM0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 07:26:14 -0500
Received: from edge1.cs.stonybrook.edu ([130.245.9.210]:31262 "EHLO
	edge1.cs.stonybrook.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2BZM0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 07:26:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ryao@cs.stonybrook.edu designates 10.50.155.231 as permitted sender) smtp.mail=ryao@cs.stonybrook.edu
MIME-Version: 1.0
In-Reply-To: <20120226104701.GA18152@polaris.bitmath.org>
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
Date: Sun, 26 Feb 2012 07:26:10 -0500
Message-ID: <CABDyM6R72WW6YnpNs+EQktaXN_Z_7cxPmABv7ojoLGbmS=+23w@mail.gmail.com>
Subject: Re: Can we move device drivers into user-space?
From: Richard Yao <ryao@cs.stonybrook.edu>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Bobby Powers <bobbypowers@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Originating-IP: [209.85.210.174]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 5:47 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> > The main issue that set me off has been sufficiently diluted in the
>> > (selective) discussion so as to no longer make sense as a reply: At
>> > some point, in-tree or out-of-tree will no longer be distinguishable,
>>
>> Please explain how you would be unable to distinguish between a driver
>> that lives in the kernel source tree, and one that does not.
>
> The SUD pointed to in the beginning of the thread is an example of
> this, but I was not thinking of it in quite so literal terms. Rather,
> I was imagining that as the kernel grows and the in-kernel interfaces
> matures, the amount of actual communication between different portions
> of the code diminishes. Code on opposite sides of a stable interface
> is, for all practical purposes, separated. Whether that code lives
> in-tree or out-of tree is then of little consequence.
>
> To try to prevent another flame war, let's make it clear that I am not
> saying that the most powerful in-kernel argument, that code can be
> changed, is unimportant. Maybe code, like so many other things,
> arranges itself in a scale-free critical fashion, which would forever
> warrant a monolithic approach. Maybe it would even make sense to have
> userspace join the same tree as well. There is however a frofoundly
> political aspect here, which cannot be expressed in terms of
> code. Also, in practise, breaking things down into manageable chunks
> is usually a good idea in the end.

I do not see what prevents an in-kernel context switch into a ring 3
context with a different process address space. Is it necessary to
remove the code from the kernel tree before someone can do this?
