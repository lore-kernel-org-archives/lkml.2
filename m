Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab1CONnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:43:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36756 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1CONnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:43:21 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=8tW7QMVCw84A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=EdFQqdYRAE2EocawMiYA:9 a=Sv-4WalIjIKorxw69GUMv8yogNoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2 2.6.38-rc8-tip 4/20] 4: uprobes: Adding and remove a
 uprobe in a rb tree.
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <alpine.LFD.2.00.1103151425060.2787@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	 <20110314133444.27435.50684.sendpatchset@localhost6.localdomain6>
	 <alpine.LFD.2.00.1103151425060.2787@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 15 Mar 2011 09:43:17 -0400
Message-ID: <1300196597.9910.269.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 14:38 +0100, Thomas Gleixner wrote:
> > +{
> > +     if (!vma->vm_file)
> > +             return 0;
> > +
> > +     if ((vma->vm_flags & (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)) ==
> > +                                             (VM_READ|VM_EXEC))
> 
> Looks more correct than the code it replaces :)
> 
> > +             return 1;
> > +
> > +     return 0;
> > +}
> > +
> 
Yeah, we had this discussion already ;)

-- Steve


