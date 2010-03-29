Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab0C2P4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:56:37 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52694 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab0C2P4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:56:36 -0400
MIME-Version: 1.0
In-Reply-To: <1269877373.6173.27.camel@iscandar.digidescorp.com>
References: <201003172118.41559.temerkhanov@cifronik.ru> <fa686aa41003261653j5a9be6e8gbe8f12e19a563cd6@mail.gmail.com> 
	<1269877373.6173.27.camel@iscandar.digidescorp.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 29 Mar 2010 09:56:15 -0600
X-Google-Sender-Auth: 435816b9166eb18b
Message-ID: <fa686aa41003290856t24a248a5j5dfda623ed2805c0@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Xilinx MPMC SDMA subsystem
To: steve@digidescorp.com
Cc: Sergey Temerkhanov <temerkhanov@cifronik.ru>,
       microblaze-uclinux@itee.uq.edu.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 9:42 AM, Steven J. Magnani
<steve@digidescorp.com> wrote:
> On Fri, 2010-03-26 at 17:53 -0600, Grant Likely wrote:
>> I've not got time to review this patch right now, but Sergey and
>> Steven, you both posted MPMC drivers on the same day; Steven on the
>> microblaze list and Sergey on the powerpc list.  Can you two please
>> coordinate and figure out how to mork toward a single driver that will
>> meet both your needs?  I don't want to have 2 drivers (3 if you count
>> the ll_temac driver) in mainline for the same hardware interface.
>>
>
> I don't think we'll end up with a single driver. A MPMC DMA Engine
> driver is useful only on "loopback" SDMA ports. Sergey's code looks like
> a nice generic interface to Xilinx SDMA HW that could be used by the
> xlldma and ll_temac drivers, for instance. Both of those will get
> smaller, but won't go away.
>
> For this to be useful to me, it would need to be located somewhere more
> accessible than arch/powerpc and it would need to have initialization
> methods that don't depend on OF. In my build I would have platform code
> that binds to the xlldma platform attachment, which would call Sergey's
> SDMA code to assign it the proper resources.

That should be fine.

> Any objections to having Sergey's code live in drivers/dma, and putting
> sdma.h out in include/linux? Might need to tweak the file/function names
> some to head off namespace issues. Or is there some other strategy for
> managing Xilinx-related drivers common to both Microblaze and PowerPC?

I have no objections.  This sounds like a good plan.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
