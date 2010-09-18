Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab0IRSwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 14:52:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41148 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab0IRSwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 14:52:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=aPNu1AWueLe9xeuOw4nliXIITmGNY1PKpEwcDZ9UQUuVSqAnXAftnRhiSI7cJMKzlw
         n3IEWDTOFAEaE4JWTlgpnCFTFHN6jkhJtZumYBwDf3fbZl+GEjtfyWy/fWA9afE6P//G
         06TczuuWI9bt3Bjg4PTzJ/y9olZT7/wE2H6Os=
MIME-Version: 1.0
In-Reply-To: <AANLkTi==kKBdOaim+fx5yhpKOo27HWhB7kQiDqv0+BPS@mail.gmail.com>
References: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTi==kKBdOaim+fx5yhpKOo27HWhB7kQiDqv0+BPS@mail.gmail.com>
Date: Sat, 18 Sep 2010 11:52:12 -0700
X-Google-Sender-Auth: b5cF_yLlFu63On2V3NFva9fyAt0
Message-ID: <AANLkTi=XH4_0UH8cN_uNzrTmf9GuASe32977gtgUVigU@mail.gmail.com>
Subject: Re: [00/12] DMAENGINE: PL08X driver updates
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 7:26 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/8/31 Linus Walleij <linus.walleij@stericsson.com>:
>
>> This updates the PL08X driver in the async_tx next branch with
>> a number of fixes and features, each one pretty self-describing.
>> This has been tested with the PrimeCell DMA series on the
>> RealView PB11MPCore and works flawlessly, multiplexing
>> several virtual clients, both devices (slaves) and memcpy
>> channels, across only two (!) available physical channels.
>
> Dan can you ACK and queue this for next?
>
> I know you're busy, just a reminder...
>

I'm back at work this coming week and will get all this queued up.

--
Dan
