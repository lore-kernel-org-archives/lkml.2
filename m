Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab1ETRlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:41:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57238 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014Ab1ETRlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:41:14 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=TwWXrjo8ZJIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=zAx4mNOmXcsE8LHOrPsA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: Steven Rostedt <rostedt@goodmis.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
In-Reply-To: <4DD6A678.6090801@linux.intel.com>
References: <201105191526.31904.toralf.foerster@gmx.de>
	 <201105192218.18261.toralf.foerster@gmx.de>
	 <20110519204342.GA10792@home.goodmis.org>
	 <201105200937.15322.toralf.foerster@gmx.de>
	 <BANLkTik0oz6ppJvRpufaaiBL1pqcAxNHuA@mail.gmail.com>
	 <4DD68EDF.4030301@linux.intel.com>
	 <1305907458.1465.23.camel@gandalf.stny.rr.com>
	 <4DD6A678.6090801@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 20 May 2011 13:41:12 -0400
Message-ID: <1305913272.1465.30.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 10:35 -0700, Darren Hart wrote:

> > Wait! This is where we need the WARN_ON_SMP(), do we have that patch in?
> 
> Hrm, I thought he said he was on 2.6.39-rc-something. Those patches went
> in pre 2.6.39-rc1 according to gitk.

A git bisect can easily stumble on this where the fix is not made.

-- Steve


