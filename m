Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab1K3MUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 07:20:08 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:12739
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103Ab1K3MUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 07:20:05 -0500
X-SpamScore: 7
X-BigFish: VPS7(z5c5ozzz1202hzzz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVH3LA-01-7YG-02
X-M-MSG: 
Date: Wed, 30 Nov 2011 13:19:57 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, hpet: Immediately disable HPET timer 1 if rtc irq
 is masked
Message-ID: <20111130121957.GC8568@alberich.amd.com>
References: <20111118153306.GB16319@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111118153306.GB16319@alberich.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can you please apply this patch?
Or are there any objections?


Regards,
Andreas


