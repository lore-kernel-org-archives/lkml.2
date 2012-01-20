Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2ATRls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:41:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57730 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab2ATRlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:41:45 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=wom5GMh1gUkA:10 a=bj2A2IsQBX4A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=vnePwSqNXyCzl2Ww_CEA:9 a=CjuIK1q_8ugA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Fri, 20 Jan 2012 12:41:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: Linux 3.3-1 out - merge window closed
Message-ID: <20120120174143.GA15673@home.goodmis.org>
References: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com>
 <20120120151452.2fe57bb87218f575e8909caf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120151452.2fe57bb87218f575e8909caf@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 03:14:52PM +1100, Stephen Rothwell wrote:
> 
> This leaves 1174 commits (13%) in v3.3-rc1 that were not in next-20120106
> for some reason (not too bad really, I guess).  Some will clearly be bug
> fixes, of course.  Some will be quilt trees (probably rebased before
> being sent to Linus).  Some will be patches that depend on work by others.

Well, 19 of those were ktest patches. Although it's not something we
need to worry about, as it's just a script for users to test their
kernels and not something that would conflict with others. I'll send out
that email to get ktest included into linux-next regardless.

Thanks!

-- Steve

