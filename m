Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab1CKBwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 20:52:09 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:8542
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753743Ab1CKBwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 20:52:07 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK1432N98dNzz1202hzz8275bhz2fh637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D798027.3040800@am.sony.com>
Date: Thu, 10 Mar 2011 17:51:35 -0800
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
        Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/22] sched: Reduce runqueue lock contention -v5
References: <20110302173831.295031866@chello.nl>
In-Reply-To: <20110302173831.295031866@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/11 09:38, Peter Zijlstra wrote:
> This patch series aims to optimize remote wakeups by moving most of the
> work of the wakeup to the remote cpu and avoid bouncing runqueue data
> structures where possible.
> 
> If there are no more 'fun' bits left I'll queue this work for .40.

For patches 01 through 22:

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>

(Comments in separate replies to patches 01, 20, 22.)

The patches just keep getting better...

-Frank

