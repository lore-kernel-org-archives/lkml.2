Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab2BZKq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 05:46:57 -0500
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:44280 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2BZKqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 05:46:55 -0500
X-SENDER-IP: [85.230.168.211]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlWiAAQNSk9V5qjTPGdsb2JhbABCiX6oJwOBBBkBAQEBNzSBcwEBBAE6HCMQCANGFCUKGogUCbZ3E4pXgi4BCRwNAgoBBgsCBgcMFAYDAoRDCAEBOwoJEgqDDmMElTyFbY0D
X-IronPort-AV: E=Sophos;i="4.73,485,1325458800"; 
   d="scan'208";a="272681436"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 26 Feb 2012 11:47:01 +0100
To: Bobby Powers <bobbypowers@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120226104701.GA18152@polaris.bitmath.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAArOQ2WCXDf2ymxihFdjKhBFMVhtoupVRB97_LsEky4HAGq0hA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The main issue that set me off has been sufficiently diluted in the
> > (selective) discussion so as to no longer make sense as a reply: At
> > some point, in-tree or out-of-tree will no longer be distinguishable,
> 
> Please explain how you would be unable to distinguish between a driver
> that lives in the kernel source tree, and one that does not.

The SUD pointed to in the beginning of the thread is an example of
this, but I was not thinking of it in quite so literal terms. Rather,
I was imagining that as the kernel grows and the in-kernel interfaces
matures, the amount of actual communication between different portions
of the code diminishes. Code on opposite sides of a stable interface
is, for all practical purposes, separated. Whether that code lives
in-tree or out-of tree is then of little consequence.

To try to prevent another flame war, let's make it clear that I am not
saying that the most powerful in-kernel argument, that code can be
changed, is unimportant. Maybe code, like so many other things,
arranges itself in a scale-free critical fashion, which would forever
warrant a monolithic approach. Maybe it would even make sense to have
userspace join the same tree as well. There is however a frofoundly
political aspect here, which cannot be expressed in terms of
code. Also, in practise, breaking things down into manageable chunks
is usually a good idea in the end.

Thanks,
Henrik
