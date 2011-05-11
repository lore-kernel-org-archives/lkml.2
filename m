Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab1EKQmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:42:05 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:55158 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1EKQmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:42:01 -0400
Date: Wed, 11 May 2011 09:25:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2] x86: UV BAU fix for non-consecutive nasids
Message-ID: <20110511072500.GJ22551@elte.hu>
References: <E1QJmxX-0002Mz-Fk@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QJmxX-0002Mz-Fk@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> (patch v2 has improved changelog and correction of a broken line)

but i did not point out just a single broken line - there's literally a dozen 
in your patch, still!

*All* of these measures i mentioned in my previous mail:

  - eliminate many repetitive strings
  - reduce indentation by the introduction of helper inlines
  - sensible shortening of variable/field/definition names

... applies to this particular case and will solve the problem.

This whole file is still utterly ugly and i'm not surprised at all it's showing 
bugs. Functions are still *way* too large and the code is hard to read.

If you don't know how to simplify a particular function then please ask but i 
see half a dozen things that could be done to clean up any of these big 
functions, just at a first quick glance. Those patterns of code ugliness repeat 
all over the whole file!

I dont mind if you do it as delta patches after this fix (so that the fix stays 
mergable) but we need to see progress in this code first, the pain in this file 
has been going on for *way* too long.

Thanks,

	Ingo
