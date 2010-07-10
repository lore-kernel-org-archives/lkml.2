Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0GJNtl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 09:49:41 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35336 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab0GJNtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 09:49:40 -0400
Date: Sat, 10 Jul 2010 15:49:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Zeev Tarantov <zeev.tarantov@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] tracing: properly align linker defined symbols
Message-ID: <20100710134938.GB15800@merkur.ravnborg.org>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com> <20100709203301.GA13839@merkur.ravnborg.org> <AANLkTinWkfkXNVA2Sx-apVQMZa-5ehugtd7JQ36np7xM@mail.gmail.com> <1278721339.1537.166.camel@gandalf.stny.rr.com> <20100710063459.GA14596@merkur.ravnborg.org> <AANLkTim7jTSaDaQTudR3e-DMBDrg9n00Hor8QdDQoVo_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim7jTSaDaQTudR3e-DMBDrg9n00Hor8QdDQoVo_@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 2.6.35-rc4 from tarball patched with only this, same config & same
> compiler boots fine.
> 
> Tested-by: Zeev Tarantov <zeev.tarantov@gmail.com>

Thanks for your paitient testing Zeev!

	Sam
