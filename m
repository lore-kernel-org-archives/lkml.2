Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab1CaT0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:26:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:28458 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759061Ab1CaT0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:26:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,277,1299484800"; 
   d="scan'208";a="904182515"
Message-ID: <4D94D545.4000000@linux.intel.com>
Date: Thu, 31 Mar 2011 12:25:57 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: paulmck@linux.vnet.ibm.com, Jan Beulich <JBeulich@novell.com>,
        Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <4D8FF8AD.5080607@cn.fujitsu.com> <4D8FF9BC.7050609@cn.fujitsu.com> <4D90647902000078000389CB@vpn.id2.novell.com> <4D924BAF.1020906@linux.intel.com> <20110329213130.GK2261@linux.vnet.ibm.com> <4D924FEE.8040804@linux.intel.com> <20110329214704.GM2261@linux.vnet.ibm.com> <4D9256AF.5000308@linux.intel.com> <20110330004725.GO2261@linux.vnet.ibm.com> <4D92BECA.50802@cn.fujitsu.com>
In-Reply-To: <4D92BECA.50802@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 10:25 PM, Lai Jiangshan wrote:
> 
> RCU is one of the most import subsystem,
> I think it is worth to do such "wrong" way.
> 

No, that's the wrong way to look at it.

RCU is important enough that it's worth creating disruption over doing
it correctly.

	-hpa
