Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718Ab0HEX4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:56:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39947 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab0HEX4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=BQYnePLXeJ0Acpb/bLWF++kfk99L67hEz1Eak5DFW9t1MF0YBf8RqvjOgeiuFtsUmw
         Wcx85SWQU9RpsBTTkXPHX7nYZo1S1YE+x1/F9SEeDQX2hqjgjv/ZmbCmlCc8Zpxz2aiR
         ah7H+s3tP0xHS1RxxjNUZ1V++1ScN50x5x95k=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20100805144336.GA26801@opensource.wolfsonmicro.com>
References: <1280979638.1238.2.camel@mola> <20100805121145.GD13146@rakim.wolfsonmicro.main> 
	<AANLkTimR8J_LqGweRpgddN3qv0oXGjnWGGiTBHQHLWi6@mail.gmail.com> 
	<20100805144336.GA26801@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 6 Aug 2010 07:56:14 +0800
Message-ID: <AANLkTinorqhrmgZ8neRc4SqoUA-r3cHfuVr55a-V8HB4@mail.gmail.com>
Subject: Re: [PATCH 1/2] lp3971: remove unnecessary ret value checking in 
	lp3971_i2c_write()
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/5 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Thu, Aug 05, 2010 at 10:22:13PM +0800, Axel Lin wrote:
>> 2010/8/5 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>
>> > but can I once more renew my request that you make some effort to
>> > provide subject lines for your patches which are consistent with the
>> > standard used for the area of the kernel you're submitting to?
>
>> I think we have communication problem.
>> I thought the subject "[PATCH 1/2] lp3971: remove unnecessary ret
>> value checking in lp3971_i2c_write()"
>> is pretty clear.
>> Or do you mean something else?
>
> In this case pretty much every regulator API patch has a subject line
> starting "regulator: " but none of your patches do this, you have
> created your own style which you use over all your patches.
>

Got your point now. Will fix it next time.

Thanks,
Axel
