Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab2BBFnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 00:43:24 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40893 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab2BBFnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 00:43:23 -0500
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.15.19
Date: Wed, 1 Feb 2012 21:43:00 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 30/41] rcutorture: Permit holding off
 CPU-hotplug operations during boot
Message-ID: <20120202054259.GQ29058@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-30-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328125319-5205-30-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:41:48AM -0800, Paul E. McKenney wrote:
> When rcutorture is started automatically at boot time, it might well
> also start CPU-hotplug operations at that time, which might not be
> desirable.  This commit therefore adds an rcutorture parameter that
> allows CPU-hotplug operations to be held off for the specified number
> of seconds after the start of boot.
> --- a/Documentation/RCU/torture.txt
> +++ b/Documentation/RCU/torture.txt
> @@ -271,11 +278,13 @@ The following script may be used to torture RCU:
>  	#!/bin/sh
>  
>  	modprobe rcutorture
> -	sleep 100
> +	sleep 3600
>  	rmmod rcutorture
>  	dmesg | grep torture:

This looks like an entirely unrelated change.

- Josh Triplett
