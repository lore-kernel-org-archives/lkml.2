Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1A2BYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 20:24:13 -0500
Received: from ch1outboundpool.messaging.microsoft.com ([157.55.116.156]:33882
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731Ab1A2BYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 20:24:12 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2011 20:24:11 EST
X-SpamScore: -9
X-BigFish: VPS-9(zzbb2dK98dNzz1202hzzz2fh2a8h637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D43689A.2040303@am.sony.com>
Date: Fri, 28 Jan 2011 17:08:42 -0800
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
Subject: Re: [RFC][PATCH 16/18] sched: Rename ttwu_post_activation
References: <20110104145929.772813816@chello.nl> <20110104150103.113685173@chello.nl>
In-Reply-To: <20110104150103.113685173@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/11 06:59, Peter Zijlstra wrote:
> The ttwu_post_actication() does the core wakeup, it sets TASK_RUNNING
> and performs wakeup-preemption, so give is a more descriptive name.

s/ttwu_post_actication/ttwu_post_activation/

-Frank

