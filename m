Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab2BCJnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:43:12 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35474 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2BCJnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:43:04 -0500
MIME-Version: 1.0
In-Reply-To: <20120203092456.GJ889@n2100.arm.linux.org.uk>
References: <CACKLOr26BuTh8Qr8pFHoTJoyCW9ty4-Kg-YRisXmN3=spzY6_Q@mail.gmail.com>
	<20120203091038.GI889@n2100.arm.linux.org.uk>
	<CACKLOr3_nsWy7z3QQejFbmgJJ78Nhv8J6fHFe=WjeAtghoCa5w@mail.gmail.com>
	<20120203092456.GJ889@n2100.arm.linux.org.uk>
Date: Fri, 3 Feb 2012 10:43:02 +0100
Message-ID: <CACKLOr0sDkaEFFCaby6H1h3hofxJdDbr4LXaFMebGWZ-46EwiQ@mail.gmail.com>
Subject: Re: [dmaengine] [Q] jiffies value does not increase in dma_sync_wait()
From: javier Martin <javier.martin@vista-silicon.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 February 2012 10:24, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Feb 03, 2012 at 10:22:00AM +0100, javier Martin wrote:
>> Hi Russell,
>>
>> On 3 February 2012 10:10, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Fri, Feb 03, 2012 at 09:37:48AM +0100, javier Martin wrote:
>> >> I've introduced a couple of printk() to check why this timeout is not
>> >> triggered and I've found that the value of jiffies does not increase
>> >> between loop iterations (i. e. it's like time didn't advance).
>> >>
>> >> Does anyobody know what reasons could make jiffies not being updated?
>> >
>> > Are interrupts disabled?
>>
>> Apparently not but, how could I check it for sure? Is
>> "irqs_disabled()" suitable for that purpose?
>
> Yes.

"irqs_disabled()" returns 0 in every iteration of the loop. So I guess
this means IRQs are properly enabled, but jiffies keeps being fixed.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
