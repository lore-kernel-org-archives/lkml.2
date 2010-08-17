Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab0HQTJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 15:09:44 -0400
Received: from mail-vw0-f66.google.com ([209.85.212.66]:52789 "EHLO
	mail-vw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0HQTJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 15:09:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=JbnfKZeWikz/NVAXE6pECFdQT2qJCIsRTSrxUr2pvTtO+EbBAue4j4t6+B+cz6OwWY
         SDoFQTbXfTfsybhil9rYbDTxMyYfZBCKIXXHahPqy89enu1lpYn/V+3mVOyKiKFoMwHH
         TnAJ1ZJMY+8fQdycTWHOXhEWKZ91/4WJmFECA=
MIME-Version: 1.0
In-Reply-To: <20100817184544.GA9486@liondog.tnic>
References: <20100817021252.GA17647@foursquare.net>
	<20100817053456.GA32714@liondog.tnic>
	<20100817062801.GA24978@foursquare.net>
	<20100817063159.GC32714@liondog.tnic>
	<20100817155333.GA17624@foursquare.net>
	<20100817162052.GA12785@a1.tnic>
	<AANLkTi=WWmOc4UVUxp_5w43zbZhP5nBfcv6oMCYNyuKE@mail.gmail.com>
	<20100817184544.GA9486@liondog.tnic>
Date: Tue, 17 Aug 2010 22:09:38 +0300
Message-ID: <AANLkTinHur0Rbnm5DFmsfM1fxFC_WQ9LxOHKsM=iKADb@mail.gmail.com>
Subject: Re: compiler warnings in 2.6.35.2
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Anca Emanuel <anca.emanuel@gmail.com>,
        Chris Frey <cdfrey@foursquare.net>, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 9:45 PM, Borislav Petkov <bp@alien8.de> wrote:
> From: Anca Emanuel <anca.emanuel@gmail.com>
> Date: Tue, Aug 17, 2010 at 08:15:21PM +0300
>
>> On Tue, Aug 17, 2010 at 7:20 PM, Borislav Petkov <bp@alien8.de> wrote:
>> > So why do you want to stay with 3.x anyway?
>>
>> Read this: http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.36-rc1-maverick/BUILD.LOG
>> Search for warnings.
>> I tried to complile myself (using ubuntu 10.10 with latest updates),
>> but failed at some staging driver. After uncheked the staging drivers,
>> still failure.
>> I'm using kernel 2.6.36-rc1 from
>> http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.36-rc1-maverick/
>
> Can you please elaborate a bit more, what are you trying to show here?
>
> --
> Regards/Gruss,
>    Boris.
>

Steps to reproduce:
1. Install Ubuntu 10.04, and upgrade to 10.10
2. Use this tutorial to compile the kernel:
https://wiki.ubuntu.com/KernelTeam/GitKernelBuild

There is a lot of compiler warnings, and this problem is not new.
I think that is enough for this moment.

( If you can boot from it please show how did you do it )
