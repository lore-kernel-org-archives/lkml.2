Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab1DSN7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:59:17 -0400
Received: from mail.perches.com ([173.55.12.10]:4836 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab1DSN7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:59:13 -0400
Subject: RE: [rfc patch] treewide: Convert "static const char <*> foo[] ="
 to "static const char <*> const foo[] ="
From: Joe Perches <joe@perches.com>
To: ym cheng <yongmingcheng@hotmail.com>
Cc: vapier.adi@gmail.com,
        Linux-kernel =?UTF-8?Q?=E9=82=AE=E4=BB=B6=E5=88=97=E8=A1=A8?= 
	<zeuux-linux-request@zeuux.org>,
        lkml <majordomo@vger.kernel.org>, "Stephen A.Rago" <sar@apuebook.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <SNT104-W3438BE3FC4EAC0A537D57EBA900@phx.gbl>
References: <1284056536.24986.182.camel@Joe-Laptop>
	 ,<AANLkTimAuA1oYyoaKsFTPEifdDsz9h=EzTB8gKudyAJk@mail.gmail.com>
	 ,<1284058127.24986.199.camel@Joe-Laptop>
	 ,<AANLkTimzAOvP62VnhpSmKoazKkPc30-YTy09g2eYPGBg@mail.gmail.com>
	 ,<1284060808.24986.231.camel@Joe-Laptop>
	 ,<AANLkTikm_ROCEZco0UMX47aD28O0EALh=WYfNwSX=fVa@mail.gmail.com>
	 ,<1284061730.24986.238.camel@Joe-Laptop>
	 ,<AANLkTinDTkW9oAG_i30YHc_Ox8ZmWU6YcNouKWYrU=Zr@mail.gmail.com>
	 ,<1284062744.24986.244.camel@Joe-Laptop>
	 <SNT104-W3438BE3FC4EAC0A537D57EBA900@phx.gbl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 06:59:12 -0700
Message-ID: <1303221552.31723.67.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 07:24 +0000, ym cheng wrote:
>   CC      arch/arm/plat-s3c24xx/gpio.o
>   CC      arch/arm/plat-s3c24xx/gpiolib.o
>   CC      arch/arm/plat-s3c24xx/time.o
> arch/arm/plat-s3c24xx/time.c:258: error: unknown field 'offset'
> specified in initializer
> arch/arm/plat-s3c24xx/time.c:258: warning: initialization from
> incompatible pointer type
> make[1]: *** [arch/arm/plat-s3c24xx/time.o] 错误 1
> make: *** [arch/arm/plat-s3c24xx] 错误 2
> 
> 
> error: unknown field 'offset' specified in initializer??????????why???
> I do not know why?
> my board is TQ2440,which is S3C2440.I want to  support hrtimer.what
> can I do now?

time.c was moved to plat-s3c in 2008.
Use a more current version?

commit b915a125112b2500d5c6fd752948afc170a49cef
Author: Ben Dooks <ben-linux@fluff.org>
Date:   Tue Oct 21 14:06:53 2008 +0100

    [ARM] S3C: Move time.c to arch/arm/plat-s3c
    
    Move time.c to arch/arm/plat-s3c
    to be shared with the S3C64XX implementations.
    
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>



