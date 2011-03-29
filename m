Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1C2JlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:41:12 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47929 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1C2JlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NUearwhL039sKG2NdlQY4BvlthSzcFrQ84NCAyv8Qs+7PUFk2LbA5hH1c3SF9ALFtJ
         fS443JVcUkclR9cpMIfwJGD5j2Sn3NJo9LXEDAr3dE9E+Xes5c71CI9ifcs//cXD0ae/
         MN4dA9QUvTj3a1tqzxFj1im3z5sP3twi+8jtg=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Kr5DQrZW+d=u-fyYcDNQogBj=TFr1_25+Z4Uw@mail.gmail.com>
References: <1300978173-9983-1-git-send-email-dbaluta@ixiacom.com>
	<20110329073632.GB10163@osiris.boeblingen.de.ibm.com>
	<AANLkTi=Kr5DQrZW+d=u-fyYcDNQogBj=TFr1_25+Z4Uw@mail.gmail.com>
Date: Tue, 29 Mar 2011 10:41:07 +0100
Message-ID: <AANLkTimaR8PW+N=tYwrD4+rXmzfm5uFv7a6SD-fWUG7B@mail.gmail.com>
Subject: Re: [PATCH] kmemleak: update documentation
From: Maxin John <maxin.john@gmail.com>
To: Daniel Baluta <dbaluta@ixiacom.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, rdunlap@xenotime.net,
        catalin.marinas@arm.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With some minor modifications, I was able to run kmemleak in MIPS platform.
Kmemleak output and Patch are available in this link:

https://lkml.org/lkml/2011/3/28/483

Should we include that information in the Documentation ?

Warm Regards,
Maxin B. John

On Tue, Mar 29, 2011 at 8:51 AM, Daniel Baluta <dbaluta@ixiacom.com> wrote:
>>> +Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.
>>
>> You missed s390.
>
> You are right.
>
> Randy, should I send a v2 of this patch, or is it already applied?
> Another option would be to send a separate patch adding s390,
> on top of my previous patch.
>
> thanks,
> Daniel.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
