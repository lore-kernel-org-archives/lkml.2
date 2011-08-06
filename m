Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab1HFPfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 11:35:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42956 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1HFPfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 11:35:12 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=JVmKiHRY1FkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=KRyvCDwr-uXSXOKY8GIA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/8] Having perf use libparsevent.a
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <CAKYOsXw+Q+h2D++LxAoCUJ3tFVEhczBgDWNjwXzuJ0mNDav_Rw@mail.gmail.com>
References: <20110805205921.909038487@goodmis.org>
	 <20110805212409.GA21114@elte.hu> <20110806004342.GG22164@somewhere>
	 <20110806064847.GB13220@elte.hu> <20110806145655.GB29058@somewhere>
	 <CAKYOsXw+Q+h2D++LxAoCUJ3tFVEhczBgDWNjwXzuJ0mNDav_Rw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 06 Aug 2011 11:35:09 -0400
Message-ID: <1312644909.18583.220.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-06 at 09:16 -0600, David Ahern wrote:

> If the library is just for parsing trace events why not call it
> libtraceparse or libtrace? This isn't perf specific functionality.

Actually, I'm thinking libevents would probably be most appropriate. It
has less to do with perf in general, and more about events. Even reading
the events goes under this category.

-- Steve

> 


