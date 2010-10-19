Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0JSWBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:01:09 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64578 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab0JSWBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ph9YAhC1TNUGCC6QAe0RIsl44qZx8HssasVSxpGiqpwNhDyJl2DUcE2l8Q7d+mZOQo
         7JNvdfevOtitTT02vAkrtn8jX2eF//oseIvBC7u403Hb8TeceE1eSpB/BJKwlDDzH+7l
         KSGfzaNnbfnNxdCH0dkzz4Co0CeqRZ8sn846I=
MIME-Version: 1.0
In-Reply-To: <20101019125250.GC12898@gondor.apana.org.au>
References: <1287236963-1705-1-git-send-email-tdent48227@gmail.com>
	<20101019125250.GC12898@gondor.apana.org.au>
Date: Tue, 19 Oct 2010 18:01:06 -0400
Message-ID: <AANLkTin1YMQT=Y_1z01RYz1-TDYY5DOy_yctTpzHg9C-@mail.gmail.com>
Subject: Re: [PATCH 01/02] Drivers: crypto: Makefile: replace the use of
 <module>-objs with <module>-y
From: Tracey Dent <tdent48227@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/10, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Sat, Oct 16, 2010 at 09:49:22AM -0400, Tracey Dent wrote:
>> Changed <module>-objs to <module>-y in Makefile.
>>
>> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
>
> I've rolled both patches into one and applied it.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>

Thanks
