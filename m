Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965011Ab1GMHSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 03:18:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64738 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab1GMHSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 03:18:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110712220036.GR2326@linux.vnet.ibm.com>
References: <20110710173530.GA16954@linux.vnet.ibm.com>
	<CAAVPGOPAx-oLZct9u2Kq3uQ4W2GwJFYUGgw3h=M_Y4_wv7b51w@mail.gmail.com>
	<20110710214639.GP6014@linux.vnet.ibm.com>
	<CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
	<20110710231449.GQ6014@linux.vnet.ibm.com>
	<CAAVPGOMSprJSkzziH6hJv9PweOONzsMaRZEK2ZSrV3xFBReTPw@mail.gmail.com>
	<20110711214301.GP2245@linux.vnet.ibm.com>
	<CAAVPGOOJ0NEWqF2w9zCLC1bpXeA_TwzenNo-a4kvR3tcbewnNw@mail.gmail.com>
	<20110712212920.GQ2326@linux.vnet.ibm.com>
	<CAAVPGOPnHb0E=vutOEQwqsUTo-wrj6_-dEv7tW096yyppMgWcw@mail.gmail.com>
	<20110712220036.GR2326@linux.vnet.ibm.com>
Date: Wed, 13 Jul 2011 12:48:06 +0530
Message-ID: <CAM=x7SafKhoS7577T0fdg_5WwYiAYaHoRhnMx0CRiHNOVws4QA@mail.gmail.com>
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
From: RKK <kulkarni.ravi4@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Jul 13, 2011 at 3:30 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Jul 12, 2011 at 10:49:22PM +0100, Julie Sullivan wrote:
>> >
>> > If this is the correct one, then the upstreamable patch I sent recently
>> > (https://lkml.org/lkml/2011/7/12/313) should also work.  Famous last
>> > words...
>> >
>> >                                                        Thanx, Paul
>>
>>
>> Indeed this works, applied to a clean v3.0-rc4  (!CONFIG_RCU_BOOST 64-bit build)
>
> Woo-hoo!!!  ;-)
>
> I have added your Tested-by and will push it out for -next testing.
>
>> Great job, Paul, thanks for all your efforts.
>> I'll test it tomorrow too on -rc5, 6 and 7 (out of time for tonight)
>
> Thinking good thoughts for the other -rc releases, and again thank you
> very much for your testing!
>
> Ravi, could you please test to make sure that it works for you?
>
sorry for being a bit late here.
just to make sure after seeing the whole thread i have applied peters
patch and yours as well .
 they  work for me too! :). thanks.
Warm Regards,
Ravi Kulkarni.
