Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab2BIRvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 12:51:23 -0500
Received: from smtp-cpk.frontbridge.com ([204.231.192.41]:44701 "EHLO
	WA2EHSNDR003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752059Ab2BIRvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 12:51:22 -0500
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: -6
X-BigFish: VS-6(zz1432N98dKzz1202h1082kzz8275dhz2dh87h2a8h668h839h944h41h42h)
X-Forefront-Antispam-Report: CIP:94.101.220.16;KIP:(null);UIP:(null);IPV:NLI;H:nzt0015e.dknz.nzcorp.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 9 Feb 2012 18:51:14 +0100
From: Anders Ossowicki <aowi@novozymes.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "JK (Jesper Agerbo Krogh)" <JK@novozymes.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Memory issues with Opteron 6220
Message-ID: <20120209175114.GA5525@otto.nzcorp.net>
Reply-To: <aowi@novozymes.com>
Mail-Followup-To: Yinghai Lu <yinghai@kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Andreas Herrmann <herrmann.der.user@googlemail.com>,
	"JK (Jesper Agerbo Krogh)" <JK@novozymes.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20120208143741.GB28486@otto.nzcorp.net>
 <20120208205628.GA18909@alberich.amd.com>
 <20120209124355.GA20902@otto.nzcorp.net>
 <20120209132825.GB8830@elte.hu>
 <20120209134920.GA25934@otto.nzcorp.net>
 <CAE9FiQUiMBUh9xSKoLj_1ZPXY3wTehB6i1V_mPmx7rs5XqMZTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQUiMBUh9xSKoLj_1ZPXY3wTehB6i1V_mPmx7rs5XqMZTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SMTP-Mail-From: aowi@otto.nzcorp.net
X-OriginatorOrg: novozymes.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 05:11:04PM +0100, Yinghai Lu wrote:
> mtrr setting has some problem too.
> 
> [    3.098277] mtrr: your CPUs had inconsistent fixed MTRR settings
> [    3.100001] mtrr: probably your BIOS does not setup all CPUs.
> [    3.110000] mtrr: corrected configuration.
> 
> can you boot with "debug ignore_loglevel show_msr=16" ?

Yep, right here:
http://dev.exherbo.org/~arkanoid/atlas-dmesg-3.2.5-20120209-mtrr.txt

-- 
Anders

