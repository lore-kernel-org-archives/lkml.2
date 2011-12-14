Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab1LNQcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:32:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35266 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab1LNQcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:32:04 -0500
X-Authority-Analysis: v=2.0 cv=Z6Nu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=x1dTjSklBAoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=_iBQ51ZGXban8YdSw38A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1323880322.23971.33.camel@gandalf.stny.rr.com>
Subject: Re: linux-next: build warnings after merge of the final tree
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Date: Wed, 14 Dec 2011 11:32:02 -0500
In-Reply-To: <20111214181545.6e13bc954cb7ddce9086e861@canb.auug.org.au>
References: <20111214181545.6e13bc954cb7ddce9086e861@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 18:15 +1100, Stephen Rothwell wrote:

> Maybe caused by commit d5e553d6e0a4 ("trace: Include <asm/asm-offsets.h>
> in trace_syscalls.c") from the tip tree.  These warnings may have been
> here for a while as it is hard to catch the new ones among the flood.
> 

hpa,

Was this change only needed for x86? If so, could you put that into
asm/ftrace.h instead?

-- Steve


