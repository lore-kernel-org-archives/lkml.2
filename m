Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935892Ab1JFWIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:08:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64325 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935612Ab1JFWIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:08:36 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=msyzJTVhAHgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=NeFGGJOzwF8m_8lAuY4A:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been
 initialized, don't nop it out
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org, rth@redhat.com
Date: Thu, 06 Oct 2011 18:08:34 -0400
In-Reply-To: <4E8E2025.30004@goop.org>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
	 <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>
	 <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org>
	 <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com>
	 <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com>
	 <4E8DEB19.1050509@goop.org> <20111006181055.GA2505@redhat.com>
	 <4E8DEFDE.4030706@zytor.com> <4E8E2025.30004@goop.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317938915.4729.31.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 14:39 -0700, Jeremy Fitzhardinge wrote:

> I'm not sure it would be a win, necessarily.  My test with back-to-back
> jmp2 was definitely slower than with the nop padding it out to 5 bytes;
> I suspect that's a result of having too many jmps within one cacheline. 
> Of course, there's no reason why the CPU would optimise for jumps to
> jumps, so perhaps its just hitting a "stupid programmer" path.

Just a note. Micro-benchmarks are known to be as good as political polls
and statistics. They show a much different view of the world than what
is really there.

-- Steve


