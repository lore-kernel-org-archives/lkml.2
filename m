Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab1EQRpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:45:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab1EQRpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:45:05 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=UWMw6JNi2FwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=-qluOdC0mre5yTn5PB8A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] x86, ftrace: Fix compiler warning in ftrace.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <BANLkTim2rcr9F=5+C9t-BU8OVfbWw5mFyQ@mail.gmail.com>
References: <1305221620.7986.4.camel@localhost.localdomain>
	 <1305648241.5456.743.camel@gandalf.stny.rr.com>
	 <BANLkTim2rcr9F=5+C9t-BU8OVfbWw5mFyQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 May 2011 13:45:02 -0400
Message-ID: <1305654302.5456.751.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 23:11 +0600, Rakib Mullick wrote:
> 
BTW, You have a weird email client. Causes lots of weird whitespace

> There are other places where they depend on __probe_kernel_write(), it
> might require to change all __probe_kernel_write() callers.

Why would callers of __probe_kernel_write() need to be changed? You can
pass any pointer into a const void*. You just can't do it the other way
around.

-- Steve

>         
> 


