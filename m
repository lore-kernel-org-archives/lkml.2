Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab0KUOXL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 09:23:11 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55495 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab0KUOXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 09:23:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RUmh7yNC2qWzi/7yPqC0Sh1xTbqEHOH89am8cJFpwNtjKGA8ED5b2+xGZw03p4hcxC
         gtdl1MIsL/vsN9tyT6/hJjW56Vdd4PCKN0x9Xk/JwPIMqwldgtyhIXqBxd/NLXVmEWL4
         2WohPEKvYxaZH09TWxvRZ2xeIa44Y3w6AbVVU=
Date: Sun, 21 Nov 2010 22:26:15 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Haicheng Li <haicheng.li@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org
Subject: Re: [patch 1/2] x86: add numa=possible command line option
Message-ID: <20101121142615.GI9099@hack>
References: <alpine.DEB.2.00.1011162359160.17408@chino.kir.corp.google.com> <20101117075128.GA30254@shaohui> <alpine.DEB.2.00.1011171304060.10254@chino.kir.corp.google.com> <20101118041407.GA2408@shaohui> <20101118062715.GD17539@linux-sh.org> <20101118052750.GD2408@shaohui> <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com> <20101119003225.GB3327@shaohui> <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com> <alpine.DEB.2.00.1011201826140.12889@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011201826140.12889@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, David

On Sat, Nov 20, 2010 at 06:28:31PM -0800, David Rientjes wrote:
>Adds a numa=possible=<N> command line option to set an additional N nodes
>as being possible for memory hotplug.  This set of possible nodes
>controls nr_node_ids and the sizes of several dynamically allocated node
>arrays.
>
>This allows memory hotplug to create new nodes for newly added memory
>rather than binding it to existing nodes.
>
>The first use-case for this will be node hotplug emulation which will use
>these possible nodes to create new nodes to test the memory hotplug
>callbacks and surrounding memory hotplug code.
>


I am not sure how much value of making this dynamic,
for CPU, we do this at compile time, i.e. NR_CPUS,
so how about NR_NODES?

Also, numa=possible= is not as clear as numa=max=, for me at least.

Thanks.
