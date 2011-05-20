Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab1ETRoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:44:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59411 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1ETRoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:44:04 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=TwWXrjo8ZJIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=qit9uHNWZye_G0qQhvYA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: Steven Rostedt <rostedt@goodmis.org>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Darren Hart <dvhart@linux.intel.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
In-Reply-To: <201105201910.13095.toralf.foerster@gmx.de>
References: <201105191526.31904.toralf.foerster@gmx.de>
	 <1305907458.1465.23.camel@gandalf.stny.rr.com>
	 <1305907896.1465.27.camel@gandalf.stny.rr.com>
	 <201105201910.13095.toralf.foerster@gmx.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 20 May 2011 13:44:02 -0400
Message-ID: <1305913442.1465.32.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 19:10 +0200, Toralf Förster wrote:

> Is there's an easy way to check, whether a given checked out git tree contains 
> a specific commit id ?

You can try:

git log --pretty=oneline | grep <SHA1>

-- Steve



