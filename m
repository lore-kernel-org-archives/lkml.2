Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab1EEOHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:07:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44355 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab1EEOH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:07:26 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1105051026370.3005@ionos>
References: <20110428192227.8979.49181.stgit@ponder> <1304386999.2513.293.camel@pasglop>
 <20110504155227.GA3317@ponder.secretlab.ca> <1304555953.2513.390.camel@pasglop>
 <alpine.LFD.2.02.1105051026370.3005@ionos>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 5 May 2011 08:07:05 -0600
X-Google-Sender-Auth: dPi5KRpRa8Sx-EzrgkhCn7Ic8u4
Message-ID: <BANLkTimQ7GsUton3nvJof8YB8k6cnx4rFQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] General device tree irq domain infrastructure
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        hpa@zytor.com, Dirk Brandewie <dirk.brandewie@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 5, 2011 at 2:37 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 5 May 2011, Benjamin Herrenschmidt wrote:
>> > As for the mapping, I agree that the functionality is generally
>> > useful, I'm just not fond of the current implementation.  I think it
>> > is more complex than it needs to be and I'm not excited about bring it
>> > over to the other architectures as-is.
>>
>> Nobody cares about the current implementation. What is important is
>> indeed the functionality. The basic thing I think everybody agrees is
>> that you need to extend the irq_desc (or data, whatever tglx prefers)
>> with two bits of information: Some identifier of the domain and some
>> identifier of the interrupt number within that domain.
>
> irq_data because that's what is handed into the callbacks and you
> probably want to have the HW number there.

Okay, I'll take another hack at it.  Unfortunately I've got a great
big unmaskable interrupt in the form of UDS next week, but I'll be
back on it the week after.

g.
