Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab2F0P0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:26:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39744 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544Ab2F0P0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <1340810283.16702.19.camel@gandalf.stny.rr.com>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com> <20120625150722.8cd4f45d.akpm@linux-foundation.org>
 <20120625235531.GB3652@kroah.com> <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
 <20120626002307.GA4389@kroah.com> <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
 <1340726856.977.6.camel@mop> <1340810038.16702.16.camel@gandalf.stny.rr.com> <1340810283.16702.19.camel@gandalf.stny.rr.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 27 Jun 2012 11:26:29 -0400
Message-ID: <CAPXgP121+zA_p4x9VdSMWtu-SqqqiNC51CKkYKY4YkAL+QsQ4g@mail.gmail.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 11:18 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2012-06-27 at 11:13 -0400, Steven Rostedt wrote:
>
>> I just tested this patch and it boots fine for me.
>
> Of course after sending this, I rebooted to the same kernel and it
> locked up :-p

Thanks for testing it. Greg had some issues too, which I can't
reproduce it on any of my boxes. I'll have a look ...

Thanks again,
Kay
