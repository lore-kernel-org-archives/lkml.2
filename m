Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab0LUBgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:36:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64600 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384Ab0LUBgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:36:41 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=bNXfipm5RCsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=08fOBlhc_8vQ5KAi92gA:9 a=FHf_jiXCONFWRVFjmPtiPWq35ZQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH 00/15] Nohz task support
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <20101220233341.GA1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292859886.22905.22.camel@gandalf.stny.rr.com>
	 <20101220233341.GA1715@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 20 Dec 2010 20:36:39 -0500
Message-ID: <1292895399.22905.68.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 00:33 +0100, Frederic Weisbecker wrote:
>  
> > I wounder if we could just have this happen automatically.
> 
> But this would add some global overhead, especially in the syscall
> path as we need to take the slow path to hook userspace resume/exit.
>  

I guess we could measure the overhead. See if the timer causes more
overhead than the added overhead of the syscall, or not.

-- Steve


