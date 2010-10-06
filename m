Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab0JFChC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 22:37:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55137 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab0JFChA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 22:37:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VYcbu+7FqJ7Z9LCHLtq8jdtm+apH94dbiBkTdM0+xu+xP8oO6QdFNbovrKvyiRAmZ7
         SFqygBhLlG611EqJUZTr2K5DDQi7+khRJoLjcCcavU23gsNvK1LVMJ7kCed7NqSkFELU
         0hqgVJX+kFkoO4KwSYzNT9K+bPm58BVB0f40o=
MIME-Version: 1.0
In-Reply-To: <20101005190551.GA23055@opensource.wolfsonmicro.com>
References: <20101005141140.0276dc14@absol.kitzblitz>
	<20101005190551.GA23055@opensource.wolfsonmicro.com>
Date: Wed, 6 Oct 2010 10:36:58 +0800
Message-ID: <AANLkTi=TgsJivTpYqfGTuwz8qjm=yJa+ur10ZAE54KBy@mail.gmail.com>
Subject: Re: [PATCH] sound/soc/nuc900: remove duplicated include
From: Wan ZongShun <mcuos.com@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Nicolas Kaiser <nikai@nikai.net>, Liam Girdwood <lrg@slimlogic.co.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/6 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Tue, Oct 05, 2010 at 02:11:40PM +0200, Nicolas Kaiser wrote:
>> Remove duplicated include.
>>
>> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
>
> Applied, but please always remember to CC maintainers on patches as
> explained in Documentation/SubmittingPatches.
>

Acked-by: Wan ZongShun <mcuos.com@gmail.com>

Thanks all.


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
