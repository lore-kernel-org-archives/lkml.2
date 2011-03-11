Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1CKCQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 21:16:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab1CKCQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 21:16:04 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=v1n8UvUeJUkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=WPyIoOwQAAAA:8 a=5Ddlv3wuwEKHWlM6bdgA:9 a=weULVtmu2G12KcOeCoJs9nhuws4A:4 a=PUjeQqilurYA:10 a=1DbiqZag68YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] jump label: introduce static_branch() interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <20110311020540.GA26622@linux-mips.org>
References: <cover.1299702291.git.jbaron@redhat.com>
	 <49b4727c7bfee19c2b7284b3339076ed827f3142.1299702291.git.jbaron@redhat.com>
	 <1299790616.15854.417.camel@gandalf.stny.rr.com>
	 <20110311020540.GA26622@linux-mips.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 21:15:59 -0500
Message-ID: <1299809759.15854.822.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-11 at 03:05 +0100, Ralf Baechle wrote:

> I'm happy with the change to arch/mips/include/asm/jump_label.h and
> assuming that the change to arch/mips/kernel/jump_label.c will be dropped

Noted.

> 
> Acked-by: Ralf Baechle <ralf@linux-mips.org>

Jason,

Could you respin the patchset and send it out again with the comments
that were made. And please Cc Ralf on any patch that touches the mips
arch.

Thanks,

-- Steve


