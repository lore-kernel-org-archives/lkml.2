Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab2HOT7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:59:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16646 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab2HOT7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:59:03 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=xNAAEMgky9QA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=2sSwxcZ2iN8A:10 a=2rFVrY8bsTbAbCyUXO0A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Subject: Re: [PATCH] sched: Support compiling out real-time scheduling with
 REALTIME_SCHED.
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trevor Brandt <tjbrandt@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>, Eric Paris <eparis@redhat.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Glauber Costa <glommer@parallels.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        team-fjord@googlegroups.com
In-Reply-To: <1345043679.31459.109.camel@twins>
References: <y> <1344977423-28900-1-git-send-email-tjbrandt@gmail.com>
	 <1345043679.31459.109.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Aug 2012 15:58:44 -0400
Message-ID: <1345060724.29444.1.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 17:14 +0200, Peter Zijlstra wrote:

> Other than that I'm not entirely happy with the growing #ifdef maze.
> Granted this new one isn't nearly as bad as some of the existing ones,
> but I do wish someone would clean up some of that.

To get rid of the #ifdefs, just make the RT scheduler into a module that
gets loaded for those that want it.

/me runs!

-- Steve


