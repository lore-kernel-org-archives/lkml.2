Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab1JDS0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:26:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932752Ab1JDS0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:26:44 -0400
Date: Tue, 4 Oct 2011 11:18:53 -0700
From: Greg KH <gregkh@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, quilt-dev <quilt-dev@nongnu.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
Message-ID: <20111004181853.GA15787@suse.de>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
 <20111004180237.GA15087@suse.de>
 <4E8B4BEC.5030708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8B4BEC.5030708@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 11:09:48AM -0700, H. Peter Anvin wrote:
> On 10/04/2011 11:02 AM, Greg KH wrote:
> > On Tue, Oct 04, 2011 at 01:46:34PM -0400, Steven Rostedt wrote:
> >> +my $pgp = `gpg --simple-sk-checksum -a --detach-sign $pass --output - < $tmpfile`;
> > 
> > Try not to use gpg when calling from scripts, use gpgv instead, it
> > handles things much better, and sets the return value correctly so you
> > can check it (which I don't think you do here.)
> > 
> 
> gpgv is only usable to verify contents (equivalent to gpg --verify).
> For other things you need to use gpg's --status-fd feature, *or*
> (perhaps better) run gpgv on the output to verify that you actually got
> a good signature.

Ah, ok, then nevermind, I guess gpg is correct here.

greg k-h
