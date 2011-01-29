Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab1A2BVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 20:21:30 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:53187
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731Ab1A2BV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 20:21:29 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zzbb2dK98dNzz1202hzz8275bhz2fh2a8h637h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D436B7B.20708@am.sony.com>
Date: Fri, 28 Jan 2011 17:20:59 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 00/18] sched: Reduce runqueue lock contention -v4
References: <20110104145929.772813816@chello.nl>
In-Reply-To: <20110104145929.772813816@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/11 06:59, Peter Zijlstra wrote:
> Latest version of the scary patches...

For patches 1 - 17:

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>

I have a few more cosmetic comments, but I'll hold off on those until
the next version of your patches, so I can put them in the proper
context of your active work instead of ancient history.

I'm also still poking some more at patch 17, being carefully paranoid.

Patch 18 I did not review yet.

-Frank

