Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab2BINta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:49:30 -0500
Received: from smtp-cpk.frontbridge.com ([204.231.192.41]:27762 "EHLO
	WA2EHSNDR006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757609Ab2BINt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:49:29 -0500
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: -6
X-BigFish: VS-6(zz1432N98dKzz1202h1082kzzz2dh87h2a8h668h839h944h41h42h)
X-Forefront-Antispam-Report: CIP:94.101.220.16;KIP:(null);UIP:(null);IPV:NLI;H:nzt0014e.dknz.nzcorp.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 9 Feb 2012 14:49:21 +0100
From: Anders Ossowicki <aowi@novozymes.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "JK (Jesper Agerbo Krogh)" <JK@novozymes.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Memory issues with Opteron 6220
Message-ID: <20120209134920.GA25934@otto.nzcorp.net>
Reply-To: <aowi@novozymes.com>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Andreas Herrmann <herrmann.der.user@googlemail.com>,
	"JK (Jesper Agerbo Krogh)" <JK@novozymes.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20120208143741.GB28486@otto.nzcorp.net>
 <20120208205628.GA18909@alberich.amd.com>
 <20120209124355.GA20902@otto.nzcorp.net>
 <20120209132825.GB8830@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120209132825.GB8830@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SMTP-Mail-From: aowi@otto.nzcorp.net
X-OriginatorOrg: novozymes.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 02:28:25PM +0100, Ingo Molnar wrote:
> Your bootlog says:
> 
> [    0.330000] Performance Events: Broken BIOS detected, complain to your hardware vendor.
> [    0.330000] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 1430076)
> 
> Do you get that message if DBPM is enabled?

It's there with System DBPM, OS DBPM and with power management disabled (i.e.
set to maximum performance).
-- 
Anders Ossowicki

