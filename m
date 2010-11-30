Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab0K3Bge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 20:36:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64594 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab0K3Bgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 20:36:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tx1LBlj9dtLBkZJRmdFQgrRJAijAOFXRUJskz1yuNthfAWf75NqJFT54TfelKgm1dU
         XZq7U70zRq4dfiTh1o7vHIkq7zKp9iIZ1rTjUlJ1cISF/7s5XbvGyB+gl5EKCgY1KFag
         3yz5g9YpZp+j8ofY+jkXoWlPnYAOoldwIVS64=
MIME-Version: 1.0
In-Reply-To: <20101129114700.GP30360@rakim.wolfsonmicro.main>
References: <1291023491.22911.1.camel@mola>
	<1291023767.22911.9.camel@mola>
	<20101129114700.GP30360@rakim.wolfsonmicro.main>
Date: Tue, 30 Nov 2010 09:36:29 +0800
Message-ID: <AANLkTinks9Msj11mfJSO9Ezwt179JYkxNKFD3dAp=X+X@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/5] ASoC: Fix missing spin_unlock_irqrestore
From: Wan ZongShun <mcuos.com@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/29 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Mon, Nov 29, 2010 at 05:42:47PM +0800, Axel Lin wrote:
>
>> I don't have this hardware handy, could you help to test this patch
>> if you think this patch is ok.
>
> I've applied everything except this one - Wan, can you let us know how
> the testing goes please?
>

Hi all,

I have tested it.

Thanks!
Acked-by: Wan ZongShun <mcuos.com@gmail.com>


-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
