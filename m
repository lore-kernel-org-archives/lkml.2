Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab2LJSjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:39:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2LJSjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:39:51 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=F1vn84g2v5IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=GbT8ctTW91IA:10 a=FHRDXCEtKMcRHx8gK9oA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355164789.17101.231.camel@gandalf.local.home>
Subject: Re: Missing tags in my local stable git repo
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 10 Dec 2012 13:39:49 -0500
In-Reply-To: <20121210181250.GC30847@kroah.com>
References: <1355160900.17101.229.camel@gandalf.local.home>
	 <20121210181250.GC30847@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 10:12 -0800, Greg Kroah-Hartman wrote:

> Can you see the tags here in your local copy of the linux-stable.git
> tree?

No I couldn't.


> Try cloning the linux-stable.git tree from scratch to see if you still
> have this issue.  Odds are, something with all of the alternates is
> getting confused somewhere.
> 

Yep, that did the trick. I just deleted my local copy and recreated it,
and all the tags are back. Sorry for the noise. Must have been a glitch
in the way alternates work and the git gc's that I do.

-- Steve


