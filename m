Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab0K2W07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:26:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61704 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab0K2W06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:26:58 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=UuO6cx77fMcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=4dVnLGxPWUpYsXh3OroA:9 a=N1v9LDrL31YJ3aPThAiwS5TxtWkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] Repalce strncmp by memcmp
From: Steven Rostedt <rostedt@goodmis.org>
To: pavel@pavlinux.ru
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1291069113.30543.876.camel@gandalf.stny.rr.com>
References: <4CF30B46.4000203@pavlinux.ru>
	 <1291042737.30543.730.camel@gandalf.stny.rr.com>
	 <4CF401DD.4000908@pavlinux.ru>
	 <1291069113.30543.876.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 29 Nov 2010 17:26:56 -0500
Message-ID: <1291069616.30543.879.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 17:18 -0500, Steven Rostedt wrote:

> Um, do you realize that the kernel does not always use the same memcmp
> as gcc.
> 

Note, I'm not against the change, because in 99% of the cases, memcmp()
can and will be faster, and we don't need to worry about these strange
cases.

What I'm against is a blind s/strncmp/memcmp/ of the kernel, because it
may have side effects that you may not have thought of.

-- Steve


