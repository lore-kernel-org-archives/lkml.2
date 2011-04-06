Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab1DFVD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:03:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab1DFVD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:03:57 -0400
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20110406201350.GA9378@linux.vnet.ibm.com>
References: <4D93D29C.5010702@cn.fujitsu.com>
	 <1301558691.2250.486.camel@laptop> <4D944E60.8080704@cn.fujitsu.com>
	 <1301570320.4859.242.camel@twins> <4D953121.6090901@cn.fujitsu.com>
	 <1301657749.4859.531.camel@twins>
	 <20110405215450.GK2247@linux.vnet.ibm.com>
	 <20110405230745.GA5972@linux.vnet.ibm.com>
	 <1302077428.2225.1365.camel@twins>
	 <20110406192119.GB2265@linux.vnet.ibm.com>
	 <20110406201350.GA9378@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 23:06:10 +0200
Message-ID: <1302123970.2207.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 13:13 -0700, Paul E. McKenney wrote:
> And the following patch builds correctly for defconfig x86 builds,
> while allowing rcupdate.h to see the sched.h definitions as needed
> to inline rcu_read_lock() and rcu_read_unlock().
> 
Looks like an entirely reasonable patch to me ;-)

