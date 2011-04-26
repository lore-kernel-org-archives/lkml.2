Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1DZQo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:44:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63779 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1DZQoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:44:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F8pbX66UxaZqGFTBSKmgta0cOcNm+HgDqMU8yWKWC8FYP3GfC9pVWQVz5GJSWScKpM
         pvwBbnt5thjb9r2EAvXHZXZprfRul8QoBN0jj0BqbzoMMr2SN+Mnxd6zVkeGcw2Cm6l+
         EJ/u248ZYgmK+BunwXfGNSZOU3zzqFhaKplVc=
MIME-Version: 1.0
In-Reply-To: <20110426094907.GE2659@sortiz-mobl>
References: <1303135451-26362-8-git-send-email-haojian.zhuang@marvell.com>
	<20110426094907.GE2659@sortiz-mobl>
Date: Wed, 27 Apr 2011 00:44:23 +0800
Message-ID: <BANLkTikX3g3+k3MPsps2N71iWsETqQXv3Q@mail.gmail.com>
Subject: Re: [PATCH 07/14] mfd: fix build warning on 88pm860x
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, a.zummo@towertech.it, johnpol@2ka.mipt.ru,
        cbou@mail.ru, dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 5:49 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Haojian,
>
> On Mon, Apr 18, 2011 at 10:04:04PM +0800, Haojian Zhuang wrote:
>> WARNING: vmlinux.o(.devinit.text+0x6c4): Section mismatch in reference
>> from the function device_onkey_init() to the (unknown reference)
>> .init.data:(unknown)
>> The function __devinit device_onkey_init() references a (unknown reference)
>>  __initdata (unknown).
>> If (unknown) is only used by device_onkey_init then annotate (unknown)
>> with a matching annotation.
>>
>> It's caused by using __initdata on mfd cell resources. Replace __initdata
>> with __devinitdata.
> Patch applied, many thanks.
>
Thanks a lot. But I can't find it in your mfd tree. Could you update
your tree? Since
I need to rebase it and format new patches.

Best Regards
Haojian
