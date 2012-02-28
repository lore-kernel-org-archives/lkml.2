Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab2B1IYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:24:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59036 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab2B1IYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:24:43 -0500
Date: Tue, 28 Feb 2012 09:24:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] x86: Cleanup and simplify cpu-specific data
Message-ID: <20120228082422.GG21106@elte.hu>
References: <1330041476-719-1-git-send-email-kjwinchester@gmail.com>
 <20120227115905.GB9943@elte.hu>
 <CAELBVzDQx-geNELEvHYheSL0hKbaXfUAvjperNcPELThT9bqWg@mail.gmail.com>
 <4F4C4D5C.70908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F4C4D5C.70908@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=AWL,BAYES_00,TRACKER_ID autolearn=no SpamAssassin version=3.3.1
  1.3 TRACKER_ID             BODY: Incorporates a tracking ID number
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
 -0.6 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> >In function ‘copy_from_user’,
> >     inlined from ‘pktgen_if_write’ at net/core/pktgen.c:877:20:
> >/home/kevin/linux/linux-2.6/arch/x86/include/asm/uaccess_32.h:211:26:
> >error: call to ‘copy_from_user_overflow’ declared with attribute
> >error: copy_from_user() buffer size is not provably correct
> >make[2]: *** [net/core/pktgen.o] Error 1
> >
> >On:
> >
> >gcc (GCC) 4.6.2 20120120 (prerelease)
> >
> >Is that my fault, or something else?
> >
> >Kevin
> >
> 
> That comes from compiling with warnings as errors.  Not that someone
> shouldn't look at that kind of problem.

Can probably be worked around by disabling:

CONFIG_DEBUG_STRICT_USER_COPY_CHECKS

Thanks,

	Ingo
