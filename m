Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab2BZP3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 10:29:42 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:47005 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2BZP3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 10:29:41 -0500
X-SENDER-IP: [85.230.168.211]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Alq2ACpPSk9V5qjTPGdsb2JhbABDiX6oJwOBBRkBAQEBNzSBcwEBBAE6HCMQCANGFCUKGogUCbZsE4pXgjgpAgoBBgsCBgcMFAMDAwKEQwgBATsKCRIKgw5jBJU8hW2NAw
X-IronPort-AV: E=Sophos;i="4.73,485,1325458800"; 
   d="scan'208";a="274601569"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 26 Feb 2012 16:29:48 +0100
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Richard Yao <ryao@cs.stonybrook.edu>, Bobby Powers <bobbypowers@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120226152948.GA19463@polaris.bitmath.org>
References: <20120224201655.GA5994@kroah.com>
 <20120224203715.GA4995@polaris.bitmath.org>
 <20120224205651.GA13333@kroah.com>
 <20120224212238.GA5178@polaris.bitmath.org>
 <20120224213027.GB15735@thunk.org>
 <20120224221459.GA5254@polaris.bitmath.org>
 <CAArOQ2WCXDf2ymxihFdjKhBFMVhtoupVRB97_LsEky4HAGq0hA@mail.gmail.com>
 <20120226104701.GA18152@polaris.bitmath.org>
 <CABDyM6R72WW6YnpNs+EQktaXN_Z_7cxPmABv7ojoLGbmS=+23w@mail.gmail.com>
 <1330266224.616.48.camel@thorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330266224.616.48.camel@thorin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > changed, is unimportant. Maybe code, like so many other things,
> > > arranges itself in a scale-free critical fashion, which would forever
> 
> "Code arranges" not itself, but people arrange code the best they see
> fit.

You seem to have missed the point of that sentence. Go pick on
somebody else.

> > > userspace join the same tree as well. There is however a frofoundly
> > > political aspect here, which cannot be expressed in terms of
> > > code. Also, in practise, breaking things down into manageable chunks
> > > is usually a good idea in the end.
> 
> Yes, everybody learns that in the first lecture on programming. Please
> sent patches to make actually things better and not just talk. Thank
> you.

I actually do on a regular basis. I wish everybody did.

Thanks.
Henrik
