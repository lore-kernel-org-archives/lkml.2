Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab2LJVug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:50:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4084 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2LJVuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:50:35 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=F1vn84g2v5IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=GbT8ctTW91IA:10 a=1XWaLZrsAAAA:8 a=d5nIyhYwf86gh31DMJIA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355176233.17101.266.camel@gandalf.local.home>
Subject: Re: Missing tags in my local stable git repo
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 10 Dec 2012 16:50:33 -0500
In-Reply-To: <1355175755.17101.263.camel@gandalf.local.home>
References: <1355160900.17101.229.camel@gandalf.local.home>
	 <1355165264.17101.233.camel@gandalf.local.home>
	 <20121210190247.GA32119@kroah.com>
	 <1355166920.17101.239.camel@gandalf.local.home>
	 <CA+55aFzvTrrM_t_K3W5s32p610MS0PuTrUUhFKaB5tGPmsW73g@mail.gmail.com>
	 <1355172274.17101.250.camel@gandalf.local.home>
	 <CA+55aFx=x9OzUvD+x+tUBxNN8EWRHEo7UuMx8OYBdyG3W+AcUw@mail.gmail.com>
	 <1355175755.17101.263.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 16:42 -0500, Steven Rostedt wrote:

> Perhaps this has nothing to do with chained alternates and git gc going
> crazy. It could have just been my linus.git tree getting corrupted, and
> then the git gc run on my stable.git tree shortly after, and corrupting
> that too. I don't reference the stable.git tree as often as I reference
> the linus.git tree, thus, I didn't put the two corruptions together.
> 

Hmm, finding my post on G+:

 https://plus.google.com/u/0/116317370665849559569/posts/Nd3HJkXAYCR

That happened on Nov 13th, almost a month ago. Hmm, I would think that I
would have noticed this earlier. Maybe the corruption was delayed?

-- Steve


