Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab1DFV1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:27:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:37191 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162Ab1DFV1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:27:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,312,1299484800"; 
   d="scan'208";a="676109785"
Message-ID: <4D9CDACB.9050705@linux.intel.com>
Date: Wed, 06 Apr 2011 14:27:39 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: paulmck@linux.vnet.ibm.com, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michal Marek <mmarek@suse.cz>, Jan Beulich <JBeulich@novell.com>,
        Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <4D93D29C.5010702@cn.fujitsu.com>	 <1301558691.2250.486.camel@laptop> <4D944E60.8080704@cn.fujitsu.com>	 <1301570320.4859.242.camel@twins> <4D953121.6090901@cn.fujitsu.com>	 <1301657749.4859.531.camel@twins>	 <20110405215450.GK2247@linux.vnet.ibm.com>	 <20110405230745.GA5972@linux.vnet.ibm.com>	 <1302077428.2225.1365.camel@twins>	 <20110406192119.GB2265@linux.vnet.ibm.com>	 <20110406201350.GA9378@linux.vnet.ibm.com> <1302123970.2207.4.camel@laptop>
In-Reply-To: <1302123970.2207.4.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 02:06 PM, Peter Zijlstra wrote:
> On Wed, 2011-04-06 at 13:13 -0700, Paul E. McKenney wrote:
>> And the following patch builds correctly for defconfig x86 builds,
>> while allowing rcupdate.h to see the sched.h definitions as needed
>> to inline rcu_read_lock() and rcu_read_unlock().
>>
> Looks like an entirely reasonable patch to me ;-)
> 

Quite... a lot better than the original proposal!

	-hpa

