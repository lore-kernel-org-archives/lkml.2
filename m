Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab0JSW1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:27:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45202 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab0JSW1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CULt2v8eBCU8MZcQRBwN+D4Il4DP7L9S+MKAKeeR64WRsCyFO3aEUMnpjwp6CJeagz
         v4cdjlduSs7Gxh3TfKWftf6LMTySho+i5NQsVWmUritUNmlDsQYCwQ50xQTmsZ5qLwBR
         MO7XjpaK77/haGxIwKp1xVm78sOdtT8yqDxGU=
MIME-Version: 1.0
In-Reply-To: <AANLkTim6vq7dPjTt4GzB6JyEDfL50H67gMacw5UbWRAm@mail.gmail.com>
References: <1286888455-11385-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTim6vq7dPjTt4GzB6JyEDfL50H67gMacw5UbWRAm@mail.gmail.com>
Date: Tue, 19 Oct 2010 15:27:11 -0700
X-Google-Sender-Auth: 6YVQ-l6KmCpz5riEl0-WSOYsEjw
Message-ID: <AANLkTi=k+2_=1JWxmfg5yk2=D4K3RkT8dV1bGdw7Y1vU@mail.gmail.com>
Subject: Re: [PATCH 0/7] ste_dma40: various fixes to the DMA40
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 8:09 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/10/12 Linus Walleij <linus.walleij@stericsson.com>:
>
>> here are some DMA40 cleanups for your immediate entertainment,
>> mostly tightening up this driver. It is getting real mature
>> now, still we need fix some smallish things...
>
> Dan are you taking these for the upcoming merge window?
> Since they change the platform data API a bit it'd be nice to
> have them in.

Yes, applied, I'll push out the result shortly.

--
Dan
