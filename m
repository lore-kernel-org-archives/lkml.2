Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab2IDPju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:39:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12898 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab2IDPjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:39:49 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0-4HISFYYNcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=_XgnefJ09S4A:10 a=imTROTZUkysA:10 a=SWp5yrndY2wA:10 a=VQ8427OFV4AA:10 a=0pmlNgc8wlsA:10 a=yvFZqJx0NNwA:10 a=TiR09M0h3c4A:10 a=-rGry1Sg3DAA:10 a=71224Grfh94A:10 a=S_QucjnRiEgA:10 a=-SyUPZm4LSYA:10 a=CEmn-lZV0i4A:10 a=F1znnlXCbRXv_Q39WwUA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346773188.27919.13.camel@gandalf.local.home>
Subject: Re: [PATCH] Add feature-removal-schedule.txt removal to
 feature-removal-schedule.txt
From: Steven Rostedt <rostedt@goodmis.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 04 Sep 2012 11:39:48 -0400
In-Reply-To: <CAM_iQpV9163UKQt8Kvroc6JyMQnv1tqG1rS5M2CBWzbo7XvJXQ@mail.gmail.com>
References: <1346091725.19381.10.camel@pippen.local.home>
	 <CAM_iQpV9163UKQt8Kvroc6JyMQnv1tqG1rS5M2CBWzbo7XvJXQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-29 at 09:28 +0800, Cong Wang wrote:
> On Tue, Aug 28, 2012 at 2:22 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > The file feature-removal-schedule.txt is ignored by most people except
> > for people that add to it. It's more of a global TODO list for
> > developers than being anything useful by anyone.
> >
> > Add a feature removal of removing the feature-removal-schedule.txt.
> >
> 
> Hi, Steven,
> 
> I sometimes remind people to remove features scheduled in this file,
> by sending a proposed patch. ;)

At Kernel Summit, Linus went on a rant about this file. He said he hates
it and is totally useless. Basically, it is only used by us developers,
and is not used by normal users. As it is a dumping ground for all
developers, this file becomes the biggest conflict during merges that
Linus does.

There are better ways to tell users something is about to go away. My
preference is a nasty WARN_ON_ONCE() in the code when the feature is
used. People tend to report call traces, and you can either tell the
person, "don't use this" or you know that it is something that is
actually used and you can't remove it.

-- Steve


