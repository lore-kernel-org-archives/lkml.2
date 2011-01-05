Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1AES53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 13:57:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48506 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab1AES52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 13:57:28 -0500
Message-ID: <4D24BED1.5000900@zytor.com>
Date: Wed, 05 Jan 2011 10:56:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Daney <ddaney@caviumnetworks.com>, Jason Baron <jbaron@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>, peterz@infradead.org,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: introduce static_branch()
References: <cover.1294239591.git.jbaron@redhat.com>	 <2d8c38bd7ca93e162aedb8e7acfc8bdb96d85de2.1294239591.git.jbaron@redhat.com>	 <4D24AB1B.2010209@caviumnetworks.com> <1294249439.26623.35.camel@gandalf.stny.rr.com>
In-Reply-To: <1294249439.26623.35.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 09:43 AM, Steven Rostedt wrote:
> On Wed, 2011-01-05 at 09:32 -0800, David Daney wrote:
> 
>> This patch will conflict with the MIPS jump label support that Ralf has 
>> queued up for 2.6.38.
> 
> Can you disable that support for now? As Linus said at Kernel Summit,
> other archs jumped too quickly onto the jump label band wagon. This
> change really needs to get in, and IMO, it is more critical to clean up
> the jump label code than to have other archs implementing it.
> 

Ralf is really good... perhaps we can get the conflicts resolved?

	-hpa
