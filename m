Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0KJOo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:44:27 -0500
Received: from canuck.infradead.org ([134.117.69.58]:43451 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab0KJOo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:44:26 -0500
Subject: Re: [RFC/Requirements/Design] h/w error reporting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Luck, Tony" <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, ying.huang@intel.com, bp@alien8.de,
        tglx@linutronix.de, akpm@linux-foundation.org, mchehab@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1289400056.12418.139.camel@gandalf.stny.rr.com>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
	 <20101110101450.GA18481@elte.hu>
	 <1289400056.12418.139.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 15:43:54 +0100
Message-ID: <1289400234.2191.129.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 09:40 -0500, Steven Rostedt wrote:
> The second option was agreed upon by myself, Thomas, Frederic, and
> Peter, and it was OK'd by Linus.
> 
> What do you think about it? 

I would still like to see lots more detail before we commit to anything,
sure the second way is the only way out, but you still need to come up
with a trace data format and a control ABI.

Without those its pretty pointless to even talk about stuff.


