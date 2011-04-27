Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab1D0Aws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 20:52:48 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:51764 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab1D0Awr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 20:52:47 -0400
Date: Tue, 26 Apr 2011 20:52:43 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
Message-ID: <20110427005243.GI9486@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 03:49:49PM -0300, Thiago Farina wrote:
> This macro is arguably more readable than its variants:
> - !strcmp(a, b)
> - strcmp(a, b) == 0
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>

I don't think this is not a good idea.

First of all, changing 2800 instances of strcmp will induce a huge
amount of code churn, that will cause patches to break, etc.  And
whether streq() looks better is going to be very much a case of
personal preference.  I'm so used to !strcmp(a, b) that streq(a, b)
would be harder for me, just because I'm not used to it.

So I'd NACK a change like this to any parts of the kernel that I'm
maintaining.  If another people feel that way, it's not clear that
having two different conventions in the kernel would necessarily help...

       	   	     		    	- Ted
