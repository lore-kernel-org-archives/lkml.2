Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab2GKVQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:16:21 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:52187 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482Ab2GKVQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:16:20 -0400
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Ksummit-2012-discuss] ARM mini-summit
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 11 Jul 2012 23:16:09 +0200
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: <ksummit-2012-discuss@lists.linux-foundation.org>, <konrad@darnok.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Organization: ARM Ltd
In-Reply-To: <201207112006.28632.arnd@arndb.de>
References: <1341994155.3522.16.camel@dabdike.int.hansenpartnership.com> <20120711140536.GC16523@phenom.dumpdata.com> <CAPbh3rsnNNFNWEf651M-mO2UFOK8pFYTMV2x7RPhjHOAyf9OJw@mail.gmail.com> <201207112006.28632.arnd@arndb.de>
Message-ID: <061ef00be9b475973e5df22fcd096308@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: arnd@arndb.de, ksummit-2012-discuss@lists.linux-foundation.org, konrad@darnok.org, James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, konrad.wilk@oracle.com
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012 20:06:28 +0000, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 11 July 2012, Konrad Rzeszutek Wilk wrote:
>> >> > contacts, with Grant and Olof joining in as time permits.
>> >>
>> >> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>> >
>> > I would be interested in attending it as well. I believe Stefano has
a
>> > strong
>> > interest as well (since he and Ian Campbell are leading the Xen ARM
>> > work).
>> 
>> And Stefano is out on vacation right now so I will serve as his phantom
>> voice
>> and say: "Yes, I am interested as well."
> 
> Ok. So are you mostly interested in discussion ARM virtualization or
other
> topics
> as well? Last time we had organized this explicitly as the "ARM subarch
> maintainer
> summit" and we might again limit the participants to the subarch
> maintainers and
> a few more people if we're running out of space, but then again if a lot
> of them
> are interested in discussion virtualization, we should probably have you
> both and 
> the ARM KVM people included as well.
> 
> We haven't even started discussing an agenda, but I'll note down your
> names as
> candidates and Xen and/or KVM as proposed topics. I'll follow up with a
> more
> formal call for topics once I have a positive confirmation from James
and
> the
> linux-foundation that we can go ahead with the ARM mini-summit.

Putting on my KVM/ARM hacker hat this time: I'd be very glad to contribute
to the discussion. There is a number of ARM-specific topics that would be
interesting to discuss regarding KVM/ARM (mainlining the damn thing, common
hypercalls?, HYP mode booting), and probably a couple of other things.

Cheers,

        M.
-- 
Fast, cheap, reliable. Pick two.
