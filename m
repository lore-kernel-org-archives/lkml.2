Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab1EKWgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:36:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42702 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab1EKWgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:36:32 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=UZYI7n2t75YA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=8nV5T6KIBtlHwaK_uPcA:9 a=nW4brO--zp0RQele7aEA:7 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20110511215111.GA16355@elte.hu>
References: <1304713252.25414.2532.camel@gandalf.stny.rr.com>
	 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
	 <20110507065803.GA23414@elte.hu>
	 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
	 <20110507144402.GC2859@elte.hu> <1304788829.11129.57.camel@frodo>
	 <20110507190033.GA11465@elte.hu> <1304996847.2969.151.camel@frodo>
	 <20110510084158.GC27426@elte.hu> <1305032797.2943.34.camel@frodo>
	 <20110511215111.GA16355@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 18:36:23 -0400
Message-ID: <1305153383.19008.1.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 23:51 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:

> Also note that IMO there is no long-term technical problem really: i agree with 
> you that we can eventually get rid of the 4 bytes bkl field as well, if all 
> affected apps migrate to libperf.so in an orderly fashion.

OK Ingo,

I'll make this my top priority. Then who knows? Maybe I'll start looking
at what I can make of your trace program. ;)

Thanks,

-- Steve


