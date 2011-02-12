Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab1BLJNU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 04:13:20 -0500
Received: from server103.greatnet.de ([83.133.97.6]:46051 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1BLJNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 04:13:16 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Feb 2011 04:13:16 EST
Message-ID: <4D564D6F.3090900@nachtwindheim.de>
Date: Sat, 12 Feb 2011 10:05:51 +0100
From: Henrik Kretzschmar <henrik@nachtwindheim.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Henrik Kretzschmar <henne@nachtwindheim.de>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: fused  X86_UP_APIC and  X86_UP_IOAPIC ?
References: <4D53BF67.50601@nachtwindheim.de>
In-Reply-To: <4D53BF67.50601@nachtwindheim.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.02.2011 11:35, schrieb Henrik Kretzschmar:
>> In commit 7cd92366a593246650cc7d6198e2c7d3af8c1d8a (x86/Voyager: remove APIC/IO-APIC Kbuild quirk / just before 2.6.29-rc4)
>> Ingo replaced the X86_UP_IOAPIC with X86_UP_APIC.
>> 
>> Was this intended ord by accident?

* Ingo Molnar <mingo@redhat.com> wrote:
> Mind sending a patch against the latest x86 tree.

Yes, I do, but just changing the config makes the compilation break,
so some prior steps are needed, since X86_APIC and X86_IO_APIC 
have fused a bit too much.

But I'm confident.

Greets,
Henrik 
