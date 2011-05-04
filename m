Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1EDV4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:56:22 -0400
Received: from mail.candelatech.com ([208.74.158.172]:55930 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab1EDV4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:56:20 -0400
Message-ID: <4DC1CAB8.5080305@candelatech.com>
Date: Wed, 04 May 2011 14:52:56 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slub: Fix the lockless code on 32-bit platforms with
 no 64-bit cmpxchg
References: <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org> <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504141413.GA14127@elte.hu> <20110504143616.GA19986@elte.hu>
In-Reply-To: <20110504143616.GA19986@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 07:36 AM, Ingo Molnar wrote:

>> From c22bd309573330e33a77c329405d9473fc14f1cb Mon Sep 17 00:00:00 2001
> From: Thomas Gleixner<tglx@linutronix.de>
> Date: Wed, 4 May 2011 15:38:19 +0200
> Subject: [PATCH] slub: Fix the lockless code on 32-bit platforms with no 64-bit cmpxchg

This patch appears to fix the crashes I was seeing on my 32-bit
Atom system.

It would crash within 30 seconds of booting every time before this patch...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

