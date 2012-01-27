Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2A0VAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:00:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40841 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab2A0VAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:00:16 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=AJ-IVAu0mgIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=G1LoyccJ20THzliuphsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327698014.22710.140.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/5] x86/jump-label: Use best default nops for inital
 jump label calls
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Michal Marek <mmarek@suse.cz>
Date: Fri, 27 Jan 2012 16:00:14 -0500
In-Reply-To: <4F230E18.2080603@zytor.com>
References: <20120127201442.080360013@goodmis.org>
	  <20120127202030.887128048@goodmis.org> <4F230899.3020808@zytor.com>
	 <1327697341.22710.138.camel@gandalf.stny.rr.com>
	 <4F230E18.2080603@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 12:50 -0800, H. Peter Anvin wrote:
> On 01/27/2012 12:49 PM, Steven Rostedt wrote:
> > 
> > If not, at the very least, I'll add a comment (in the last patch) that
> > explains why we use our own "JUMP_LABEL_INIT_NOP" instead of
> > ASM_NOP5_ATOMIC.
> > 
> 
> Then at least use GENERIC_NOP5_ATOMIC instead of open-coding it.

OK, I can do that. Hehe, I looked for the x86_32 version, but it was so
obfuscated that I didn't find it. Thanks for pointing it out.

-- Steve


