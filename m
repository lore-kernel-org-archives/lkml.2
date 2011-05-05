Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1EEOOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:14:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:37006 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab1EEOOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:14:41 -0400
Message-ID: <4DC2B0C8.6010306@linutronix.de>
Date: Thu, 05 May 2011 16:14:32 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, hpa@zytor.com,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 0/6] General device tree irq domain infrastructure
References: <20110428192227.8979.49181.stgit@ponder> <1304386999.2513.293.camel@pasglop> <20110504155227.GA3317@ponder.secretlab.ca> <1304555953.2513.390.camel@pasglop> <alpine.LFD.2.02.1105051026370.3005@ionos> <BANLkTimQ7GsUton3nvJof8YB8k6cnx4rFQ@mail.gmail.com>
In-Reply-To: <BANLkTimQ7GsUton3nvJof8YB8k6cnx4rFQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> Okay, I'll take another hack at it.  Unfortunately I've got a great
> big unmaskable interrupt in the form of UDS next week, but I'll be
> back on it the week after.

And I thought you were a NMI.

> 
> g.

Sebastian
