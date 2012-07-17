Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2GQF3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:29:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47962 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752253Ab2GQF3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:29:18 -0400
Message-ID: <1342502957.8377.125.camel@joe2Laptop>
Subject: Re: [PATCH] ftrace: using pr_fmt for better printk output
From: Joe Perches <joe@perches.com>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jul 2012 22:29:17 -0700
In-Reply-To: <CACV3sb+EoHPqM7ih-5HpiT-o9CqobhaiJJ3E7-8H7N=tR7URig@mail.gmail.com>
References: <CACV3sb+CkmMtBSRe=bp4EcN3xXD+XqBKy+o_-Cr7e6bapYQftw@mail.gmail.com>
	 <1342496521.8377.105.camel@joe2Laptop>
	 <1342499125.24525.11.camel@gandalf.stny.rr.com>
	 <CACV3sb+EoHPqM7ih-5HpiT-o9CqobhaiJJ3E7-8H7N=tR7URig@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 13:23 +0800, Jovi Zhang wrote:
> I don't make sure if there have some method or skill to let GCC knows
> subsystem name automatically,
> use built-in macro __FILE__? but this need condition of subsystem name
> is same as file name,
> not so easily to guarantee that.

You could use KBUILD_BASENAME instead.

