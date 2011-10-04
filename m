Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487Ab1JDTLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:11:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39125 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab1JDTLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:11:40 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=ccdOYuaMiZkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=M8GHAg5MMT_-D55Ls94A:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: quilt-dev <quilt-dev@nongnu.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andreas Gruenbacher <agruen@suse.de>
Date: Tue, 04 Oct 2011 15:11:35 -0400
In-Reply-To: <1317754795.32543.32.camel@twins>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
	 <1317754795.32543.32.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317755496.18063.20.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 20:59 +0200, Peter Zijlstra wrote:
> On Tue, 2011-10-04 at 13:46 -0400, Steven Rostedt wrote:
> > Added the quilt mail option --pass to allow the user to enter a
> > passphrase and sign their email patches.
> > 
> > Thanks to Peter Zijlstra for recommending --use-agent to solve the
> > issues of both the passphrase in unlocked memory, and typing something
> > wrong. 
> 
> How about another option that also allows you to pick they key used for
> signing things?

I already thought about that. I wanted to get this working first, and
add that as a new "feature" ;)

-- Steve


