Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab1CLDXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 22:23:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41571 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1CLDXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 22:23:43 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=-nbtLg5rJTMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=zdHwtiK0q9CRDJSJk_kA:9 a=Rdc6C6DFCp7LsMrLO59da0ABexsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/4] futex,plist: updates
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <20110312031435.890203189@goodmis.org>
References: <20110312031435.890203189@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 11 Mar 2011 22:23:42 -0500
Message-ID: <1299900222.9910.64.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-11 at 22:14 -0500, Steven Rostedt wrote:

> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git
> 
>     branch: rt/tip/futex/devel

Ug! There was a bug in my internal scripts. the "rt/" part is my
internal branch and is not in the name that I push out. that should have
been:

     branch: tip/futex/devel

-- Steve


