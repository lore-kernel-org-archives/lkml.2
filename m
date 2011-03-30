Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1C3K61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:58:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48592 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab1C3K6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:58:25 -0400
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, paulmck@linux.vnet.ibm.com,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20110330105505.GA3195@sepie.suse.cz>
References: <4D8FF9BC.7050609@cn.fujitsu.com>
	 <4D90647902000078000389CB@vpn.id2.novell.com>
	 <4D924BAF.1020906@linux.intel.com>
	 <20110329213130.GK2261@linux.vnet.ibm.com>
	 <4D924FEE.8040804@linux.intel.com>
	 <20110329214704.GM2261@linux.vnet.ibm.com>
	 <4D9256AF.5000308@linux.intel.com>
	 <20110330004725.GO2261@linux.vnet.ibm.com> <4D92BECA.50802@cn.fujitsu.com>
	 <4D92DA32.2010809@cn.fujitsu.com>  <20110330105505.GA3195@sepie.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Mar 2011 12:57:36 +0200
Message-ID: <1301482656.4859.171.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 12:55 +0200, Michal Marek wrote:
> Subject: [PATCH] headers: Allow for lightweight inclusion of task_struct definition
> 
> Factor out a couple of type definitions to <header>_types.h to allow
> using task_struct without pulling tons of new dependencies via sched.h.

Urgh, not pretty.. so why not clean up sched.h properly? There's way too
much cruft in there.
