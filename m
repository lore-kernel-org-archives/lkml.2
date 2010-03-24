Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab0CXJeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:34:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:50966 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab0CXJeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:34:10 -0400
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from
 e820.c to fw_memmap.cy
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jbarnes@virtuousgeek.org, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20100324090031.GA23804@elte.hu>
References: <4BA80019.5000900@kernel.org>
	 <alpine.LFD.2.00.1003230046050.3147@localhost.localdomain>
	 <4BA813A4.1010704@kernel.org>
	 <alpine.LFD.2.00.1003230213260.3147@localhost.localdomain>
	 <4BA8594F.8090205@kernel.org> <20100323080252.GA4848@elte.hu>
	 <4BA883C0.2070102@kernel.org> <20100323094834.GB4576@elte.hu>
	 <1269404982.8599.148.camel@pasglop> <1269405882.8599.155.camel@pasglop>
	 <20100324090031.GA23804@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 20:32:57 +1100
Message-ID: <1269423177.8599.214.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 10:00 +0100, Ingo Molnar wrote:
> > I'm a bit too flat out right now to write code, but if there's no objection, 
> > I might give that a go either later this week or next week, see if I can 
> > replace bootmem on powerpc.
> 
> That would be fantastic! PowerPC and x86 both doing it would give it enough of 
> a critical mass to make the removal of bootmem realistic.

>From the look of it, I wont' have any bandwidth this week tho ... but
let's keep that as a plan for moving forward and who gets to do it first
wins a free beer at the next conference :-)

Cheers,
Ben.


