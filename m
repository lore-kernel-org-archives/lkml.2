Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2LJVXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:23:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25204 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab2LJVX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:23:29 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=F1vn84g2v5IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=GbT8ctTW91IA:10 a=VwQbUJbxAAAA:8 a=lpMYTlfUf9b6BEJUZTQA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355174607.17101.251.camel@gandalf.local.home>
Subject: Re: Missing tags in my local stable git repo
From: Steven Rostedt <rostedt@goodmis.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 10 Dec 2012 16:23:27 -0500
In-Reply-To: <m2vcc9oblu.fsf@igel.home>
References: <1355160900.17101.229.camel@gandalf.local.home>
	 <1355165264.17101.233.camel@gandalf.local.home>
	 <20121210190247.GA32119@kroah.com>
	 <1355166920.17101.239.camel@gandalf.local.home>
	 <CA+55aFzvTrrM_t_K3W5s32p610MS0PuTrUUhFKaB5tGPmsW73g@mail.gmail.com>
	 <1355172274.17101.250.camel@gandalf.local.home> <m2vcc9oblu.fsf@igel.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 22:12 +0100, Andreas Schwab wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > [remote "origin"]
> >         fetch = +refs/*:refs/*
> >         mirror = true
> >         url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > [remote "stable"]
> >         url = git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> >         fetch = +refs/heads/*:refs/heads/*
> 
> This is your problem.  When fetching from origin all references
> (including tags) not part of origin are removed.  When you mirror a repo
> you cannot have another remote in the same repo.

Note, the above was my proposal to merge stable.git with linus.git. It's
not what I currently have.

-- Steve


