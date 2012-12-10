Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2LJV1C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:27:02 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30794 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2LJV1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:27:00 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=F1vn84g2v5IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=GbT8ctTW91IA:10 a=VwQbUJbxAAAA:8 a=EZgRptLl5THt_ucJ5CoA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355174818.17101.255.camel@gandalf.local.home>
Subject: Re: Missing tags in my local stable git repo
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 10 Dec 2012 16:26:58 -0500
In-Reply-To: <20121210211854.GA26470@kroah.com>
References: <1355160900.17101.229.camel@gandalf.local.home>
	 <1355165264.17101.233.camel@gandalf.local.home>
	 <20121210190247.GA32119@kroah.com>
	 <1355166920.17101.239.camel@gandalf.local.home>
	 <CA+55aFzvTrrM_t_K3W5s32p610MS0PuTrUUhFKaB5tGPmsW73g@mail.gmail.com>
	 <1355172274.17101.250.camel@gandalf.local.home>
	 <20121210211854.GA26470@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 13:18 -0800, Greg Kroah-Hartman wrote:

> > Am I making any sense? ;-)
> 
> Kind of,

I'm glad you understand it, because I sure don't ;-)

>  but would would be even easier is if you just have one
> "origin", pointing at linux-stable.git, and then every so often just do:
> 	git checkout master
> 	git pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

Both my stable.git and my linus.git are bare repositories. No working
directory, as that would add a lot of unnecessary files and waste disk
space. You can't do a git checkout on a bare repository.

> 
> As the master branch of linux-stable.git always is a "clean" linux.git
> tree, although it might lag a few -rc releases back if I have forgotten
> to update it recently.  When it does get updated, all should be fine as
> the master branch has no merges from anything else, so it's just a
> fast-forward.

I also need the latest linus tree all the time. Unless your stable tree
has a branch from Linus's master, I will still need to directly get
Linus's tree.

> 
> That might be simpler overall than the different repos to be pulling
> from in different ways.

Unfortunately it wont work due to the requirement that the repos be
bare.

-- Steve


