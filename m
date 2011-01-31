Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1AaUQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:16:02 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51983 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab1AaUQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:16:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=aXw0jsJMbTf/sEj2yHCUC6AVod5ple8mj9C39VW5CR773AeaFimwDjdfeKWfqvo4jg
         9+zK/TTx/mU8S7DLyKbXo7nobCe2yvyVyqdjkesvMLKwyf3MmOKDpo9AC/DlWZYGsLeu
         8Gxqre3A2hU35G9luoPq6PbpJf+JO6HfSnSmo=
Date: Mon, 31 Jan 2011 23:15:55 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: [PATCH] bq27x00_battery: Add new properties
Message-ID: <20110131201555.GA31249@oksana.dev.rtsoft.ru>
References: <20110131135147.GB3883@oksana.dev.rtsoft.ru>
 <20110131154354.GC3819@enneenne.com>
 <20110131160321.GA23546@oksana.dev.rtsoft.ru>
 <AANLkTikr3LL-+4LObBaCTo7JGTFTRdVbpbbUH4nfJ28X@mail.gmail.com>
 <4D470B42.7050301@metafoo.de>
 <20110131192242.GB23722@sirena.org.uk>
 <AANLkTi=zc_Ft6K=QP70-fUASO+0pO_2O8Cp6W6LL08MS@mail.gmail.com>
 <20110131193810.GK5123@opensource.wolfsonmicro.com>
 <AANLkTinWiG=v-Mwt+tBBSFN43w4f0qifmr+v=mArB0u0@mail.gmail.com>
 <AANLkTi=ySBY3=-kyL0x3GbzmNELWi7Ot=nivuVVwHov6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=ySBY3=-kyL0x3GbzmNELWi7Ot=nivuVVwHov6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 09:04:32PM +0100, Pali Rohár wrote:
> This patch adds MODULE_DEVICE_TABLE for module bq27x00_battery.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Tested-by: Pali Rohár <pali.rohar@gmail.com>

Lars, if that's OK for you, please take Pali's patches via your
tree. I can merge it into battery-2.6.git on request (and after
review, of course).

Thanks!

> 
> --- a/drivers/power/bq27x00_battery.c   2011-01-31 20:58:11.000000000 +0100
> +++ b/drivers/power/bq27x00_battery.c   2011-01-31 20:57:05.000000000 +0100
> @@ -596,6 +596,7 @@ static const struct i2c_device_id bq27x0
>         { "bq27500", BQ27500 },
>         {},
>  };
> +MODULE_DEVICE_TABLE(i2c, bq27x00_id);
> 
>  static struct i2c_driver bq27x00_battery_driver = {
>         .driver = {

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
