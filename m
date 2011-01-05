Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1AESnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 13:43:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38700
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab1AESny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 13:43:54 -0500
Date: Wed, 05 Jan 2011 10:44:25 -0800 (PST)
Message-Id: <20110105.104425.71112703.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: ddaney@caviumnetworks.com, jbaron@redhat.com, ralf@linux-mips.org,
        peterz@infradead.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, sam@ravnborg.org,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: introduce static_branch()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1294249439.26623.35.camel@gandalf.stny.rr.com>
References: <2d8c38bd7ca93e162aedb8e7acfc8bdb96d85de2.1294239591.git.jbaron@redhat.com>
	<4D24AB1B.2010209@caviumnetworks.com>
	<1294249439.26623.35.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 05 Jan 2011 12:43:59 -0500

> On Wed, 2011-01-05 at 09:32 -0800, David Daney wrote:
> 
>> This patch will conflict with the MIPS jump label support that Ralf has 
>> queued up for 2.6.38.
> 
> Can you disable that support for now? As Linus said at Kernel Summit,
> other archs jumped too quickly onto the jump label band wagon.

I totally disagree with this assesment.  Implementing jump label for
sparc64 as early as possible found so much broken stuff that otherwise
would have merged in before any other architecture tried supporting
it.

