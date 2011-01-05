Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1AERoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:44:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37868 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab1AERoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:44:02 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=mIBq1ZzCEX8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ETOHwMdwKKQxYHaxwDwA:9 a=V8Sm6oWOqsAjdLb1qBG5gl4F9o0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] jump label: introduce static_branch()
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Jason Baron <jbaron@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
        peterz@infradead.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <4D24AB1B.2010209@caviumnetworks.com>
References: <cover.1294239591.git.jbaron@redhat.com>
	 <2d8c38bd7ca93e162aedb8e7acfc8bdb96d85de2.1294239591.git.jbaron@redhat.com>
	 <4D24AB1B.2010209@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 05 Jan 2011 12:43:59 -0500
Message-ID: <1294249439.26623.35.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 09:32 -0800, David Daney wrote:

> This patch will conflict with the MIPS jump label support that Ralf has 
> queued up for 2.6.38.

Can you disable that support for now? As Linus said at Kernel Summit,
other archs jumped too quickly onto the jump label band wagon. This
change really needs to get in, and IMO, it is more critical to clean up
the jump label code than to have other archs implementing it.

-- Steve


