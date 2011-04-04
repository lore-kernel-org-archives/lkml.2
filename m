Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab1DDQFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:05:45 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:50883 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab1DDQFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:05:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KDkNsjQrkWNYV+GOdSqYtOkFa283igW/Ur6ytSwtKljRl53KXuPZBbqasDmFcLdGle
         lIygDKx9OjGsjuIGiEcPU+ZNTbLbvMjr9U356vUNYcARi3DsWlu83EQFyfEnlF+BCBkP
         nQMv1b9tOV1r98vlaX27+Ajkyl46kTOH9E4nQ=
MIME-Version: 1.0
In-Reply-To: <20110404083747.34ed1398.randy.dunlap@oracle.com>
References: <20110404143546.e2bb3379.sfr@canb.auug.org.au>
	<20110404083747.34ed1398.randy.dunlap@oracle.com>
Date: Tue, 5 Apr 2011 00:05:43 +0800
Message-ID: <BANLkTim6uL6ui24fNRwhYsBDX-zFhOBNgg@mail.gmail.com>
Subject: Re: linux-next: Tree for April 4 (sound/soc)
From: =?GB2312?B?uN/N8sH6?= <gaowanlong@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems like that you can't say n with the CONFIG_I2C

2011/4/4, Randy Dunlap <randy.dunlap@oracle.com>:
> On Mon, 4 Apr 2011 14:35:46 +1000 Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20110401:
>
>
> When CONFIG_SPI=n, CONFIG_I2C=n:
>
> sound/soc/soc-cache.c:418: error: implicit declaration of function
> 'i2c_master_send'
> sound/soc/soc-cache.c:421: error: implicit declaration of function
> 'do_spi_write'
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
