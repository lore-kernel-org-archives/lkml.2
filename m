Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1H3XDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 19:03:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192Ab1H3XDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 19:03:16 -0400
Date: Tue, 30 Aug 2011 16:02:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 2/4] posix-timers: limit the number of posix timers per
 process
Message-Id: <20110830160238.90eaa998.akpm@linux-foundation.org>
In-Reply-To: <4E5D6893.5010505@linux.intel.com>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
	<1314661157-22173-2-git-send-email-andi@firstfloor.org>
	<20110830144407.acdae071.akpm@linux-foundation.org>
	<4E5D5EE6.3070708@linux.intel.com>
	<20110830152216.dffd3cc3.akpm@linux-foundation.org>
	<4E5D6893.5010505@linux.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 15:47:47 -0700
Andi Kleen <ak@linux.intel.com> wrote:

> 
> > Yes, deployment for new rlimits is a big PITA.  It would be sensible to
> > modify the shells to take some anonymous numeric argument, so you could
> > do
> >
> > 	ulimit 42 1000
> >
> > to set rlimit number 42 if your shell version doesn't understand the
> > symbolic representation of more recent additions.  Who do I call?
> 
> I guess sending a patch to the bash maintainers?
> 

That would help ;)  And all the other shells :(

It would be worth going back and taking another look at the writable
/proc/<pid>/limits patches (http://lwn.net/Articles/365732/).  Why
didn't that work get merged?
