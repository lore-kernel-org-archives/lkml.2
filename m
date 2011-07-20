Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1GTPxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 11:53:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55816 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1GTPxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 11:53:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110720145939.GB2352@linux.vnet.ibm.com>
References: <20110719224142.GT2357@linux.vnet.ibm.com>
	<CAM=x7SbY8Z8jmarRougaJPxxR8gHi2MKtCUkq8Yi4JYCBo=JAw@mail.gmail.com>
	<20110720145939.GB2352@linux.vnet.ibm.com>
Date: Wed, 20 Jul 2011 21:23:06 +0530
Message-ID: <CAM=x7SbUJyZuCsgc_mfkgYZ4hyZz4iK7ASs7hyW5jfyGP-2Zwg@mail.gmail.com>
Subject: Re: Fw: RCU boot debug patch
From: RKK <kulkarni.ravi4@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: kernelmail.jms@gmail.com, linux-kernel@vger.kernel.org, cmm@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul

>>
>> On Wed, Jul 20, 2011 at 4:11 AM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > Hello, Julie and Ravi,
>> >
>> > Although we arrived at a patch that worked for both of you, we never did
>> > identify exactly which RCU callback (or other issue) that was causing
>> > the problem.  It would be good to do this in case there is some other
>> > problem lurking that might bite us in the future.  Mingming has therefore
>> > put together the following diagnostic patch which should identify the
>> > callbacks, please see below.
>> >
>> > So could you please run this and let us know what you find?  There should
>> > at least be a message for artificial_callback().
>> >
>>
>>  Do i need to  apply this patch on today's Linus master or on -rc7 ?
>
> Please do not use -rc7, as that would reproduce your hang.  Linus master
> tree would be best, but -rc7 with the fix applied would work fine as well.
>

Ok. will apply against Linus Master tree and get back to you sometime
later tonight.



Warm Regards,
Ravi Kulkarni.
