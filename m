Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0JPCLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 22:11:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47299 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0JPCLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 22:11:32 -0400
X-Authority-Analysis: v=1.1 cv=exbvkCqEOBXDkHq+8n3wanotOBQtbe7qbIajSD+JluU= c=1 sm=0 a=JTWUBG3XEXkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=knYdJiMsgPGpYvN2KBAA:9 a=KWci5k1kjoSFv4RLOcAA:7 a=VfW8YDS3eCYEI1BsfdxTfwHfIWsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 5/9] jump label: Add
 register_jump_label_key/unregister_jump_label_key
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <1287176290.1998.114.camel@laptop>
References: <20101015200949.134732894@goodmis.org>
	 <20101015201036.923619508@goodmis.org>  <1287176290.1998.114.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Oct 2010 22:11:30 -0400
Message-ID: <1287195090.16971.40.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 22:58 +0200, Peter Zijlstra wrote:
> On Fri, 2010-10-15 at 16:09 -0400, Steven Rostedt wrote:
> >  
> >  static inline void jump_label_lock(void) {}
> >  static inline void jump_label_unlock(void) {}
> > +static inline void register_jump_label_key(unsigned long key) {}
> > +static inline void unregister_jump_label_key(unsigned long key) {}
> > 
> shouldn't we call that jump_label_register_key() and co?

I believe a lot of code has register/unregister first in its name.

-- Steve



