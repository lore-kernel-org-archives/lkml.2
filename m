Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0FWTpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:45:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37052 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab0FWTpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:45:50 -0400
X-Authority-Analysis: v=1.1 cv=4GK1Slht3WUdSXXcSOu+TCe3GQnvEFDsQSvVHKX2gdo= c=1 sm=0 a=VT3f0z-SXmYA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=ijvh-uqoNxbpdy8Ix98A:9 a=Aa-osqySh_7p6KDs9HOUXalZZcQA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 08/40] tracing: remove syscall bitmaps in preparation
 for compat support
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jason Baron <jbaron@redhat.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <20100623193455.GE2680@redhat.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
	 <1277287401-28571-9-git-send-email-imunsie@au1.ibm.com>
	 <1277306204.9181.43.camel@gandalf.stny.rr.com>
	 <20100623191454.GC2680@redhat.com>  <20100623193455.GE2680@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 23 Jun 2010 15:45:47 -0400
Message-ID: <1277322347.9181.54.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-23 at 15:34 -0400, Jason Baron wrote:

> Actually, looking at this further, what we probably want to do change
> the "int nb_args" field, which is already in syscall_metadata into a bit
> field. nb_args I think can be at most 6, or 3 bits, and we only need 4
> bits for storing the enabled/disabled data, so we could even make it a
> char. Thus, actually saving space with this patch :) (at least as far as
> the syscall_metadata field is concerned).

Yeah, I'm fine with turning that into a count/flags field.

-- Steve


