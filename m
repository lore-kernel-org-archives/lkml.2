Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0LBBRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 20:17:51 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:5194 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755449Ab0LBBRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 20:17:50 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK1432N98dNzz1202hzzz2fh2a8h691h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4CF6F39D.5090202@am.sony.com>
Date: Wed, 1 Dec 2010 17:17:17 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        tglx <tglx@linutronix.de>
Subject: Re: [PATCH RFC] reduce runqueue lock contention
References: <20100520204810.GA19188@think>	 <1277114522.1875.469.camel@laptop> <1277117647.1875.503.camel@laptop>	 <1277125479.1875.510.camel@laptop> <1277213586.1875.704.camel@laptop>	 <20100622211141.GC21149@elte.hu> <1277284257.1875.820.camel@laptop> <4CF6D694.4030003@am.sony.com>
In-Reply-To: <4CF6D694.4030003@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/10 15:13, Frank Rowand wrote:

< snip >

>   The patch was created on the -top tree.

Fat-fingered typing.  That should be the -tip tree....

-Frank

