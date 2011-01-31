Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1AaUEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:04:20 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55858 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab1AaUET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:04:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=t0a4QkFdv4EonO6G+AEowpkUNwf++tYazfWzEDZ/EV2gjYvjaVxOFGMGz91HSsv4XI
         qCJfE/b8gHrnbnePHMQW/VX4EXUOoP3I+EjpQ/1M6ub2PBXmE7Tuan/8iEEqzSdc49r+
         DDQq+MwigqSx+hxu7j5pYkVMirGFr7bKSm+oE=
MIME-Version: 1.0
In-Reply-To: <20110131193810.GK5123@opensource.wolfsonmicro.com>
References: <20110131135147.GB3883@oksana.dev.rtsoft.ru> <20110131154354.GC3819@enneenne.com>
 <20110131160321.GA23546@oksana.dev.rtsoft.ru> <AANLkTikr3LL-+4LObBaCTo7JGTFTRdVbpbbUH4nfJ28X@mail.gmail.com>
 <4D470B42.7050301@metafoo.de> <20110131192242.GB23722@sirena.org.uk>
 <AANLkTi=zc_Ft6K=QP70-fUASO+0pO_2O8Cp6W6LL08MS@mail.gmail.com> <20110131193810.GK5123@opensource.wolfsonmicro.com>
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Mon, 31 Jan 2011 21:03:36 +0100
Message-ID: <AANLkTinWiG=v-Mwt+tBBSFN43w4f0qifmr+v=mArB0u0@mail.gmail.com>
Subject: Re: Fwd: [PATCH] bq27x00_battery: Add new properties
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/31 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Mon, Jan 31, 2011 at 08:35:47PM +0100, Pali Rohár wrote:
>
>> Can you give me example how to use MODULE_DEVICE_TABLE (if alias is
>> not good solution)?
>
> git grep MODULE_DEVICE_TABLE\(i2c
>
> provides quite a few examples.
>

Thanks. I removed MODULE_ALIAS and added MODULE_DEVICE_TABLE. modinfo
tell me that module has alias too (same as my defined).

-- 
Pali Rohár
pali.rohar@gmail.com
