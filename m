Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab0G2PLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:11:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64941 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab0G2PLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:11:08 -0400
MIME-Version: 1.0
X-Originating-IP: [66.187.234.200]
In-Reply-To: <20100729123941.GL8564@aniel.lan>
References: <20100728162855.4968e561.sfr@canb.auug.org.au>
	<20100728102417.be60049a.randy.dunlap@oracle.com>
	<20100728220454.GK8564@aniel.lan>
	<4C50AC26.1080100@oracle.com>
	<AANLkTi=DLHOnzgXmpzNE3PQXp-xSkm8vLdxBBf1mcFuO@mail.gmail.com>
	<AANLkTimTbZ6Vjqe5rqNVtNwPV=qoo=BOsOwG_6fS1SZU@mail.gmail.com>
	<20100729123941.GL8564@aniel.lan>
Date: Thu, 29 Jul 2010 11:11:06 -0400
Message-ID: <AANLkTinBmLd0GnoiPNm5=UhakSVo-wEJDSA-5E+ufPGQ@mail.gmail.com>
Subject: Re: linux-next: Tree for July 28 (lirc #2)
From: Jarod Wilson <jarod@wilsonet.com>
To: Janne Grunau <j@jannau.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        lirc-list@lists.sourceforge.net, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 8:39 AM, Janne Grunau <j@jannau.net> wrote:
> On Thu, Jul 29, 2010 at 12:27:01AM -0400, Jarod Wilson wrote:
>> On Wed, Jul 28, 2010 at 6:27 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
>> > On Wed, Jul 28, 2010 at 6:16 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> >> On 07/28/10 15:04, Janne Grunau wrote:
>> >>> On Wed, Jul 28, 2010 at 10:24:17AM -0700, Randy Dunlap wrote:
>> >>>> On Wed, 28 Jul 2010 16:28:55 +1000 Stephen Rothwell wrote:
>> >>>>
>> >>>>> Hi all,
>> >>>>>
>> >>>>> Changes since 20100727:
>> >>>>
>> >>>>
>> >>>> When USB_SUPPORT is not enabled and MEDIA_SUPPORT is not enabled:
>> >>>>
>> >>>
>> >>> following patch should fix it
>> >>>
>> >>> Janne
>> >>
>> >> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
>> >>
>> >> Thanks.
>> >
>> > Acked-by: Jarod Wilson <jarod@redhat.com>
>> >
>> > Indeed, thanks much, Janne!
>>
>> D'oh, I should have looked a bit closer... What if instead of making
>> all the drivers depend on both LIRC && LIRC_STAGING, LIRC_STAGING just
>> depends on LIRC?
>
> I started adding LIRC to each driver by one. Adding LIRC as LIRC_STAGING
> dependency is simpler. See updated patch.
>
>> And there are a few depends lines with duplicate
>> USB's in them and LIRC_IMON should have USB added to it (technically,
>
> D'oh, I've must have stopped reading after LIRC_STAG...
>
> fixed and added additional dependencies

Yeah, that looks better, thanks! (And this time I looked more carefully).

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
