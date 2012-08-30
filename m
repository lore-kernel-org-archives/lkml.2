Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab2H3TF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 15:05:57 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47085 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2H3TF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 15:05:56 -0400
X-Originating-IP: 217.70.178.145
X-Originating-IP: 173.246.103.110
Date: Thu, 30 Aug 2012 12:05:48 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 4/5] rcu: Switch rcutorture to pr_alert()
 and friends
Message-ID: <20120830190548.GE6749@jtriplet-mobl1>
References: <20120830184448.GA31753@linux.vnet.ibm.com>
 <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352312-31987-4-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346352312-31987-4-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:45:11AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Drop a few characters by switching kernel/rcutorture.c from
> "printk(KERN_ALERT" to "pr_alert(".
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

How about setting pr_fmt as well, and dropping the various "rcutorture:"
prefixes?  You'd still potentially want to add the torture type, though
you could do that with pr_fmt as well.

In any case:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
