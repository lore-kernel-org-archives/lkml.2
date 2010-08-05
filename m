Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600Ab0HEOWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:22:35 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40116 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760285Ab0HEOWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:22:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=TW1UcPBfyTS0Xehfi2q1oa+IZBLbmKtvRxEHPISOdsNGnbKZmEOPN07JOR0ttlw4Mv
         6ZZQH6sol1Oe8DpjkNOHK2iDCMobAEQjScmmTy57Z2Uwwk4DVZC2Jc65Edgx9KCkOqvM
         NVBiHOx2wzAyYnf/Y7Z80aEYlvpix3K+jFNEE=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20100805121145.GD13146@rakim.wolfsonmicro.main>
References: <1280979638.1238.2.camel@mola> <20100805121145.GD13146@rakim.wolfsonmicro.main>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 5 Aug 2010 22:22:13 +0800
Message-ID: <AANLkTimR8J_LqGweRpgddN3qv0oXGjnWGGiTBHQHLWi6@mail.gmail.com>
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

hi Mark,

2010/8/5 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Thu, Aug 05, 2010 at 11:40:38AM +0800, Axel Lin wrote:
>> i2c_smbus_write_byte_data() returns zero or negative value,
>> therefore no need to check if ret is greater than zero or not.
>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> but can I once more renew my request that you make some effort to
> provide subject lines for your patches which are consistent with the
> standard used for the area of the kernel you're submitting to?
>

I think we have communication problem.
I thought the subject "[PATCH 1/2] lp3971: remove unnecessary ret
value checking in lp3971_i2c_write()"
is pretty clear.
Or do you mean something else?

Regards,
Axel
