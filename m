Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350Ab1JDSPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:15:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44085 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853Ab1JDSPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:15:48 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=ccdOYuaMiZkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=EuwzkBDnoTvlqInh8SIA:9 a=z7OqrR8jk91J0oEXTX4A:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@suse.de>
Cc: quilt-dev <quilt-dev@nongnu.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 04 Oct 2011 14:15:46 -0400
In-Reply-To: <20111004180237.GA15087@suse.de>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
	 <20111004180237.GA15087@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317752148.18063.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 11:02 -0700, Greg KH wrote:
> On Tue, Oct 04, 2011 at 01:46:34PM -0400, Steven Rostedt wrote:
> > +my $pgp = `gpg --simple-sk-checksum -a --detach-sign $pass --output - < $tmpfile`;
> 
> Try not to use gpg when calling from scripts, use gpgv instead, it
> handles things much better, and sets the return value correctly so you
> can check it (which I don't think you do here.)

You're right, I don't check the return value. I haven't figured out a
good way to pass that back to the script. Hmm, an error in the pipe
would kill the pipe.

> 
> Now if only someone can get quilt working properly for git's "split"
>  subject: lines, I would be very happy...

What issues do you have? I use quilt to send git patches all the time.

What are git's "split" subject: lines?

-- Steve


