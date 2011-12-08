Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab1LHBB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:01:29 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:25801 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946Ab1LHBB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:01:27 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzzz2fh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4EE00C51.5080509@am.sony.com>
Date: Wed, 7 Dec 2011 17:01:05 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.2-rc4-rt6
References: <alpine.LFD.2.02.1112052205350.2735@ionos>
In-Reply-To: <alpine.LFD.2.02.1112052205350.2735@ionos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/11 13:09, Thomas Gleixner wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.2-rc4-rt6 release.

Builds and boots on some ARM boards (PandaBoard, Realview) for:

  - SMP, PREEMPT_RT_FULL
  - SMP, PREEMPT_NONE
  - UP, PREEMPT_RT_FULL
  - UP, PREEMPT_NONE

I'm still fighting with my out of mainline ARM board to move it
to 3.2-rc and boot SMP.

-Frank

