Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab0HEBoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 21:44:21 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62956 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759277Ab0HEBoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 21:44:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=kiOAsNXg97HPNhLVBXuFu2Eu1tYN8NjylIKDMzIhRdrj4ia0uPGcGmf1x+/z8a8LNF
         y9tUHNtJpHTtZPvGBYgYh8wSatT6L4Q13XgkSJf9YVUkkyJrJuu2GNS/kLYB6lA34b4K
         P05tXl1jZxYaLBT1fv6mUla6bV8/ZjZVEwhJM=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20100804075025.GA22446@rakim.wolfsonmicro.main>
References: <1280903650.8393.1.camel@mola> <20100804075025.GA22446@rakim.wolfsonmicro.main>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 5 Aug 2010 09:43:57 +0800
Message-ID: <AANLkTikrj1O_SgD2TGTdy4Y=SHPuo2Y7eJv-wGvcaxsD@mail.gmail.com>
Subject: Re: [PATCH] max8998: fix off-by-one value range checking
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/4 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Aug 04, 2010 at 02:34:10PM +0800, Axel Lin wrote:
>> In max8998_list_voltage() and max8998_set_voltage(),
>> we use ldo as array index of ldo_voltage_map.
>> Thus the valid range should be 0 .. ARRAY_SIZE(ldo_voltage_map)-1.
>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> Axel, please do try to bear in mind my previous comments about supplying
> subject lines for your commits consistent with those for the relevant
> code area.  This makes your patches easier to apply.
>
OK, will improve it next time.

Regards,
Axel
