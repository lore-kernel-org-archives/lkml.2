Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964867Ab1CaICx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 04:02:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:47453 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964828Ab1CaICo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 04:02:44 -0400
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>,
        paulmck@linux.vnet.ibm.com, Jan Beulich <JBeulich@novell.com>,
        Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <4D93D29C.5010702@cn.fujitsu.com>
References: <4D8FF9BC.7050609@cn.fujitsu.com>
	 <4D90647902000078000389CB@vpn.id2.novell.com>
	 <4D924BAF.1020906@linux.intel.com>
	 <20110329213130.GK2261@linux.vnet.ibm.com>
	 <4D924FEE.8040804@linux.intel.com>
	 <20110329214704.GM2261@linux.vnet.ibm.com>
	 <4D9256AF.5000308@linux.intel.com>
	 <20110330004725.GO2261@linux.vnet.ibm.com> <4D92BECA.50802@cn.fujitsu.com>
	 <4D92DA32.2010809@cn.fujitsu.com>  <20110330105505.GA3195@sepie.suse.cz>
	 <1301482656.4859.171.camel@twins> <4D931814.9090100@suse.cz>
	 <4D93D29C.5010702@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 10:04:51 +0200
Message-ID: <1301558691.2250.486.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 09:02 +0800, Lai Jiangshan wrote:
> I like this cleanup, could you continue for this hard job? I will help
> you if required.
> 
> Ingo & Peter - will you accept the patches when it is done.
> 
No, like I said, I think the proposed patch is utterly horrid.

