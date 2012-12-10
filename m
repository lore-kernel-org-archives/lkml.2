Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab2LJTP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:15:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8487 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab2LJTPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:15:22 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=F1vn84g2v5IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=GbT8ctTW91IA:10 a=87xUQ97rLOogvmQqcEMA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355166920.17101.239.camel@gandalf.local.home>
Subject: Re: Missing tags in my local stable git repo
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 10 Dec 2012 14:15:20 -0500
In-Reply-To: <20121210190247.GA32119@kroah.com>
References: <1355160900.17101.229.camel@gandalf.local.home>
	 <1355165264.17101.233.camel@gandalf.local.home>
	 <20121210190247.GA32119@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 11:02 -0800, Greg Kroah-Hartman wrote:
> On Mon, Dec 10, 2012 at 01:47:44PM -0500, Steven Rostedt wrote:
> > On Mon, 2012-12-10 at 12:35 -0500, Steven Rostedt wrote:
> > 
> > > I have a crontab that updates these every night with a 'git remote
> > > update' and once a week they do a 'git gc' on these repos. I notice the
> > > above issues after the git gc.
> > 
> > Looking at my script that does the git gc, it runs:
> > 
> >  git gc --aggressive
> > 
> > on the stable.git tree. I wonder if that made a difference.

I know we're beating a dead horse here, but it would be interesting to
know where the corruption came from.

> 
> I think 'git gc' might have cause the problem, as it looks like it
> pruned branches that you hadn't accessed in a long time, so it cleaned
> them up.

That's a scary thought... git gc will just prune stuff you haven't used
in a while? I hope that's not the case.

-- Steve


