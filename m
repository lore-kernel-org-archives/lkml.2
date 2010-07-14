Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab0GNXkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:40:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59803 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab0GNXkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:40:52 -0400
X-Authority-Analysis: v=1.1 cv=g9Y3NohClm0xo0Au7hiKM/lwvZwqTqjWC8eysRFNA3U= c=1 sm=0 a=ZI5MULQygNwA:10 a=ood2b7iyd8MA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=Mg6adXEl9tgf5WbaUv4A:9 a=1eGiirTedtfo6eVo-0gA:7 a=m4yAjOr8uqzNIkJ87n1DXUDuaiQA:4 a=QEXdDO2ut3YA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <20100714231117.GA22341@Krystal>
References: <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	 <20100714170617.GB4955@Krystal>
	 <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	 <20100714184642.GA9728@elte.hu>
	 <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
	 <20100714193652.GA13630@nowhere>
	 <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>
	 <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal>
	 <20100714224853.GC14533@nowhere>  <20100714231117.GA22341@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 19:40:44 -0400
Message-ID: <1279150844.4190.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ /me removes the duplicate email of himself! ]

On Wed, 2010-07-14 at 19:11 -0400, Mathieu Desnoyers wrote:
> > 
> > So, when an event triggers in perf, we sometimes want to capture the stacktrace
> > that led to the event.
> > 
> > We want this stacktrace (here we call that a callchain) to be recorded
> > locklessly. So we want this callchain buffer per cpu, with the following
> > type:
> 
> Ah OK, so you mean that perf now has 2 different ring buffer implementations ?
> How about using a single one that is generic enough to handle perf and ftrace
> needs instead ?
> 
> (/me runs away quickly before the lightning strikes) ;)
> 

To be fair, that's just a temp buffer.

-- Steve

(/me sends this to try to remove the dup email he's getting )

