Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1AEUE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:04:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab1AEUE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 15:04:58 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=mIBq1ZzCEX8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=hM8SXfMd5unFFwBgY-YA:9 a=d3gTl3bBEBlot48b5vsyIQf9QDQA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] jump label: introduce static_branch()
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: ddaney@caviumnetworks.com, jbaron@redhat.com, ralf@linux-mips.org,
        peterz@infradead.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, sam@ravnborg.org,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <20110105.104425.71112703.davem@davemloft.net>
References: <2d8c38bd7ca93e162aedb8e7acfc8bdb96d85de2.1294239591.git.jbaron@redhat.com>
	 <4D24AB1B.2010209@caviumnetworks.com>
	 <1294249439.26623.35.camel@gandalf.stny.rr.com>
	 <20110105.104425.71112703.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 05 Jan 2011 15:04:53 -0500
Message-ID: <1294257893.26623.116.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 10:44 -0800, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Wed, 05 Jan 2011 12:43:59 -0500
> 
> > On Wed, 2011-01-05 at 09:32 -0800, David Daney wrote:
> > 
> >> This patch will conflict with the MIPS jump label support that Ralf has 
> >> queued up for 2.6.38.
> > 
> > Can you disable that support for now? As Linus said at Kernel Summit,
> > other archs jumped too quickly onto the jump label band wagon.
> 
> I totally disagree with this assesment.  Implementing jump label for
> sparc64 as early as possible found so much broken stuff that otherwise
> would have merged in before any other architecture tried supporting
> it.

The issue here is that jump labels went in too fast. And I agree that
having it ported to all archs is/was important. But the infrastructure
needs to be cleaned up.

Probably best to get out the kinks in Linux next as suppose to mainline.

-- Steve


