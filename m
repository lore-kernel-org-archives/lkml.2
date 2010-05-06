Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab0EFJDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:03:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38372 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab0EFJC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=W9YDyCyikWeQ3qEZiEayOrCq5JrgEL9LYSXrRYBvY2XYs1B7/VCNVhzi2sSZaYb9Qa
         6UesVeFxzxtJ/VtBi5xkBicvB8mbrLuRbpkRF4CJjf7Ljl8CBkrI87r/J27YQce08PXg
         z0EHvNJWcgyQO5E2OVGw62ec5TNt59eDhYRSE=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1273136225.2992.21.camel@odin>
References: <1273116816.26133.1.camel@mola> <1273136225.2992.21.camel@odin>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 6 May 2010 17:02:39 +0800
Message-ID: <z2p427d64721005060202g2da71211j38b21416b69fcb94@mail.gmail.com>
Subject: Re: [PATCH RESEND] mc13783-regulator: fix vaild voltage range 
	checking for mc13783_fixed_regulator_set_voltage
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Liam,

2010/5/6 Liam Girdwood <lrg@slimlogic.co.uk>:
> On Thu, 2010-05-06 at 11:33 +0800, Axel Lin wrote:
>> In the case of "min_uV == max_uV == mc13783_regulators[id].voltages[0]",
>> mc13783_fixed_regulator_set_voltage should return 0 instead of -EINVAL.
>>
>> This patch also adds a missing ">" character for MODULE_AUTHOR, a trivial fix.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
>> ---
>>  drivers/regulator/mc13783-regulator.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>
> Both patches look the same. Is there any reason for the resend ?
I just found  my mail client make the first patch not able to be
cleanly applied by git-am.
The resend one fix it, and should be cleanly applied by git-am command.

Regards,
Axel

>
> Thanks
>
> Liam
>
>
