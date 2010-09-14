Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0INFcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 01:32:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51945 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0INFci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 01:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UBHtsVgf4KzrpkCG0yqYrJnk2rw72/ohv3YiDEDUE4R40hOGYFO34XyoNdLcakDZlW
         DCgGWJ4rWA3g2enbarDF00EpP/XAUvpa067Q+LWG89uwRCzvKETew2ordg9HuyAAgu0t
         OqIzv9Nq0E6zN3k3S8GFHI0RElgcuOKN/wahc=
MIME-Version: 1.0
In-Reply-To: <20100913214132.0438615242D@gemini.denx.de>
References: <AANLkTi=tWwaFHB0DY=j0UaqbYdYJpGJpmWdGC4aMufSw@mail.gmail.com>
	<20100913214132.0438615242D@gemini.denx.de>
Date: Tue, 14 Sep 2010 07:32:37 +0200
Message-ID: <AANLkTimWLpazRTDdGsXRrTYCjJQURM8ydv2TcX_PycWM@mail.gmail.com>
Subject: Re: ARM target not boot after remap memory
From: Robin Theunis <robint91@gmail.com>
To: Wolfgang Denk <wd@denx.de>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Wolfgang,

I messed up the buildroot and u-boot version!
u-boot = 2010.06
and
buildroot = 2010.08

Sorry all, my fault.

Best regards,

Robin Theunis

2010/9/13 Wolfgang Denk <wd@denx.de>:
> Dear Robin Theunis,
>
> In message <AANLkTi=tWwaFHB0DY=j0UaqbYdYJpGJpmWdGC4aMufSw@mail.gmail.com> you wrote:
>>
>> The U-boot version is 2010.08. I have build the whole system on a
>
> There is no such version of U-Boot.
>
> Best regards,
>
> Wolfgang Denk
>
> --
> DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
> What is tolerance? -- it is the consequence of humanity. We  are  all
> formed  of frailty and error; let us pardon reciprocally each other's
> folly -- that is the first law of nature.                  - Voltaire
>
