Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab2BZJym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 04:54:42 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:33959 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2BZJyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 04:54:41 -0500
X-SENDER-IP: [85.230.168.211]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoVeADAASk9V5qjTPGdsb2JhbABDDoUZhEWpLhkBAQEBNzSBcwEBBAEjDwEjIwULCAMODAImAgIUJQoaiBQJpVWRAxOBHItvAQcBBgQRCQIKAQYEBwIGBwwUBgMChEMIATwKCRIKglszYwSVPIVtjEs4
X-IronPort-AV: E=Sophos;i="4.73,485,1325458800"; 
   d="scan'208";a="1814441300"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 26 Feb 2012 10:54:47 +0100
To: Theodore Tso <tytso@MIT.EDU>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120226095447.GA18141@polaris.bitmath.org>
References: <20120224191535.GA4505@polaris.bitmath.org>
 <20120224192643.GB24120@kroah.com>
 <20120224201027.GA4859@polaris.bitmath.org>
 <20120224201655.GA5994@kroah.com>
 <20120224203715.GA4995@polaris.bitmath.org>
 <20120224205651.GA13333@kroah.com>
 <20120224212238.GA5178@polaris.bitmath.org>
 <20120224213027.GB15735@thunk.org>
 <20120224221459.GA5254@polaris.bitmath.org>
 <717014CA-C53C-4001-BD60-B742468DA0BD@MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <717014CA-C53C-4001-BD60-B742468DA0BD@MIT.EDU>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> … and the performance is terrible --- as it must be.  If you don't
> understand why this must be, then we're wasting our time having this
> conversation.

You are right, I don't understand the assumptions leading to that
conclusion. It does not seem to stop people from experimenting with
filesystems that do no even reside within the same computer (hdfs).

> And if you're the one wanting to make a change, then you are the one
> who has to provide the proof.

I know the drill, and I obviously already got hit on the head. ;-)

> Otherwise we're just talking about
> hypotheticals, and that way lies over-design.  Why waste time
> engineering something that may never come to pass?

This is a seriously defensive attitude, given that the thread was
hypothetical from the start.

> Of course, your time is something you are free to spend however you
> like.  So if you want to try implementing some of these grand plans
> of yours, show us the code….

If I put on rose-colored glasses and try really hard, I can almost
interpret this as an invitation to share code.

Thanks.
Henrik
