Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab2C2SbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:31:09 -0400
Received: from fifo99.com ([67.223.236.141]:60696 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759931Ab2C2SbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:31:00 -0400
Date: Thu, 29 Mar 2012 11:30:59 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [RFC] Android Logger vs. Shared Memory FIGHT!
Message-ID: <20120329183058.GF16476@fifo99.com>
References: <20120328210631.GB2297@fifo99.com>
 <20120329145055.GE13912@fifo99.com>
 <4F748CF6.4010205@am.sony.com>
 <20120329175209.GE16476@fifo99.com>
 <4F74A7E1.3010500@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F74A7E1.3010500@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 11:20:17AM -0700, Tim Bird wrote:
> Putting bogus pids in the log would allow a log DDOS-er to hide their
> activity more easily.  But with the log in user-space, there are much more
> insidious things that could be done to hide or corrupt log activity.  So
> the sensitivity of this particular piece of log data is not that great.
>  -- Tim


	Bogus pids or real pids it doesn't matter you can't map the pid
back to the process.

	It's true that you can wipe the whole shared memory area if it's
in userspace, but there are ways to handle that .. Not to mention
motivation due to a massive speed up over logger. For instance each app
could log to it's own logging area, and the permissions wouldn't allow
any other app to write into that area..

	You know a DoS process could just not log anything .. There's far too
many other ways to kill the system..

Daniel
