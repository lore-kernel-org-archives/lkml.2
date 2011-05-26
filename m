Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab1EZWOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:14:11 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:47489 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab1EZWOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:14:06 -0400
MIME-Version: 1.0
In-Reply-To: <20110526220120.GN24876@n2100.arm.linux.org.uk>
References: <BANLkTiknh4nCviohecbcJEiWnSW-JdMxDw@mail.gmail.com>
 <alpine.LFD.2.00.1105241435550.3207@xanadu.home> <BANLkTi=hCpCbNzi1ZiKmGnbhmCG2Ce=EkA@mail.gmail.com>
 <201105261559.41993.arnd@arndb.de> <20110526150655.GA26661@ponder.secretlab.ca>
 <20110526220120.GN24876@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 26 May 2011 16:13:46 -0600
X-Google-Sender-Auth: E4GZ-2Cm7oKzVjdwF96zLgLjZeM
Message-ID: <BANLkTi=mL=J4UeKgFEa9y3C==8f9eKkboA@mail.gmail.com>
Subject: Re: [PATCH] ARM: Xilinx: Adding zynq platform support
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 4:01 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, May 26, 2011 at 09:06:55AM -0600, Grant Likely wrote:
>> On Thu, May 26, 2011 at 03:59:41PM +0200, Arnd Bergmann wrote:
>> > On Wednesday 25 May 2011, Grant Likely wrote:
>> > >
>> > > As per discussion attached below.  Please pull this tree adding device
>> > > tree support to ARM, plus some other minor device tree changes.
>> >
>> > Hi Grant and Linus,
>> >
>> > There is also the new Xilinx zynq subarchitecture pending that depends
>> > on this, see below. Should we also include that right away, in order
>> > to have an example for other platforms? I think the code is clean
>> > enough and it would be good to have.
>> >
>> >     Arnd
>>
>> Yes, this one definitely should (as we discussed in Budapest 2 weeks back).
>> Its been in linux-next for a while now too.
>>
>> I've picked it up into devicetree/arm-next and run through a few build
>> tests before I push it out and update the pull request.
>
> Note that I've pulled the dt stuff into my tree a few days ago already.

Even better.  Thanks.

g.
