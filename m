Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1KPQuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:50:15 -0500
Received: from smtp-out-055.synserver.de ([212.40.185.55]:1090 "HELO
	smtp-out-054.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752993Ab1KPQuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:50:13 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 19322
Message-ID: <4EC3E9E5.7030909@metafoo.de>
Date: Wed, 16 Nov 2011 17:50:45 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111010 Iceowl/1.0b2 Icedove/3.1.15
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 2/7] regmap: Make reg_config reg_defaults const
References: <1321457302-8724-1-git-send-email-lars@metafoo.de> <1321457302-8724-2-git-send-email-lars@metafoo.de> <20111116161316.GI29986@opensource.wolfsonmicro.com> <4EC3E385.4060006@metafoo.de> <20111116162442.GL29986@opensource.wolfsonmicro.com> <4EC3E684.90109@metafoo.de> <20111116163908.GN29986@opensource.wolfsonmicro.com>
In-Reply-To: <20111116163908.GN29986@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 05:39 PM, Mark Brown wrote:
> On Wed, Nov 16, 2011 at 05:36:20PM +0100, Lars-Peter Clausen wrote:
>> On 11/16/2011 05:24 PM, Mark Brown wrote:
> 
>>> Did you actually check the sparse output?
> 
>> No, because the only place we ever look at config->reg_defaults is in
>> regache_init. And now I just run sparse and as expected regmap doesn't
>> trigger any warnings or errors.
> 
>   CHECK   drivers/base/regmap/regmap.c
> drivers/base/regmap/regmap.c:162:27: warning: incorrect type in assignment (different modifiers)
> drivers/base/regmap/regmap.c:162:27:    expected struct reg_default *reg_defaults
> drivers/base/regmap/regmap.c:162:27:    got struct reg_default const *const reg_defaults

Hu? which patches did you apply? If I have regmap/for-next plus patch 1 and
patch 2 of this series there isn't even a reference to reg_defaults in regmap.c
