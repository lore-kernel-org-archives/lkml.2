Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0I2PGf convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Wed, 29 Sep 2010 11:06:35 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63740 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab0I2PGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AR3FaT35iunUWyopmu79alVyanSKZuSS/c1i8FUX3jnlyLCPAOFydmQdQF239/+cpW
         cYfYROi2xxz+viSlN1Tv7vfM6+N4Qmp20imjIPqgFO3PqKm1ScrYLIiPgW6DYDLPlY73
         IeAwVUrFOvGFtxOR/iv2DeXnPqEB7pK6hgNjU=
MIME-Version: 1.0
In-Reply-To: <20100929080113.5581c19d.rdunlap@xenotime.net>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTinYExzihm6BuP=amLDwMO-zXejeUq5xeHL4ETg_@mail.gmail.com>
	<20100929080113.5581c19d.rdunlap@xenotime.net>
Date: Wed, 29 Sep 2010 17:05:07 +0200
Message-ID: <AANLkTim0+vCOMQ9QXGWbEn_n7x=znZkVEQ36xmCT6hsY@mail.gmail.com>
Subject: Re: mmotm 2010-09-28-16-13 uploaded
From: Na Pohybel <napohybelskurwysynom2010@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from QUOTED-PRINTABLE to 8bit by mail.home.local id o8TF7ntm007663

2010/9/29 Randy Dunlap <rdunlap@xenotime.net>:
> On Wed, 29 Sep 2010 15:13:41 +0200 N.P.S. N.P.S. wrote:
>
>> 2010/9/29  <akpm@linux-foundation.org>:
>> > The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to
>>
>> Another randconfig thing
>>
>> drivers/net/pch_gbe/pch_gbe_main.c: In function 'pch_gbe_tx_queue':
>> drivers/net/pch_gbe/pch_gbe_main.c:965: error: implicit declaration of
>> function 'tcp_hdr'
>> drivers/net/pch_gbe/pch_gbe_main.c:965: error: invalid type argument
>> of '->' (have 'int')
>> drivers/net/pch_gbe/pch_gbe_main.c:968: error: invalid type argument
>> of '->' (have 'int')
>> drivers/net/pch_gbe/pch_gbe_main.c:976: error: implicit declaration of
>> function 'udp_hdr'
>> drivers/net/pch_gbe/pch_gbe_main.c:976: error: invalid type argument
>> of '->' (have 'int')
>> drivers/net/pch_gbe/pch_gbe_main.c:980: error: invalid type argument
>> of '->' (have 'int')
>> make[3]: *** [drivers/net/pch_gbe/pch_gbe_main.o] Error 1
>> make[2]: *** [drivers/net/pch_gbe] Error 2
>> make[1]: *** [drivers/net] Error 2
>> make: *** [drivers] Error 2
>
> Patch has been sent to DaveM and he has merged it.

Thanks again!

>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>



-- 
Slawa!
N.P.S.
