Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1C2Vcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:32:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:51044 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab1C2Vcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:32:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,264,1299484800"; 
   d="scan'208";a="726660556"
Message-ID: <4D924FEE.8040804@linux.intel.com>
Date: Tue, 29 Mar 2011 14:32:30 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Jan Beulich <JBeulich@novell.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <4D8FF8AD.5080607@cn.fujitsu.com> <4D8FF9BC.7050609@cn.fujitsu.com> <4D90647902000078000389CB@vpn.id2.novell.com> <4D924BAF.1020906@linux.intel.com> <20110329213130.GK2261@linux.vnet.ibm.com>
In-Reply-To: <20110329213130.GK2261@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 02:31 PM, Paul E. McKenney wrote:
>>
>> I have to say that if we have to use hardcoded offsets in C then we have
>> bigger problems.
> 
> In this case, the offsets are mechanically generated from the structure
> definitions.
> 
> Or am I missing your point?
> 

Yes.  The point is if we have to pull out these kinds of hacks in *C*
code, we are doing it wrong.  Not just a little wrong, but completely
and totally bonkers wrong.

	-hpa
