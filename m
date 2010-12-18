Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0LRBDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 20:03:47 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:30418
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756487Ab0LRBDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 20:03:46 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK1432N98dNzz1202hzz8275bhz2fh2a8h637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D0C0850.90007@am.sony.com>
Date: Fri, 17 Dec 2010 17:03:12 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Chris Mason <chris.mason@oracle.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/5] sched: Always provide p->oncpu
References: <20101216145602.899838254@chello.nl> <20101216150920.761726663@chello.nl>
In-Reply-To: <20101216150920.761726663@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/10 06:56, Peter Zijlstra wrote:
> Always provide p->oncpu so that we can determine if its on a cpu
> without having to lock the rq.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Looks good to me.

Acked-by: Frank Rowand <frank.rowand@am.sony.com>

