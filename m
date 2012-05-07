Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab2EGOsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:48:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16568 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975Ab2EGOsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:48:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 07 May 2012 07:48:28 -0700
Message-ID: <4FA7DFF9.5010606@nvidia.com>
Date: Mon, 7 May 2012 20:15:13 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 4/4] regulator: tps62360: Provide settling time for
 voltage change
References: <1336376139-1048-1-git-send-email-ldewangan@nvidia.com> <1336376139-1048-5-git-send-email-ldewangan@nvidia.com> <20120507112321.GI4415@opensource.wolfsonmicro.com> <4FA7C31C.7000309@nvidia.com> <20120507142245.GF17002@opensource.wolfsonmicro.com>
In-Reply-To: <20120507142245.GF17002@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 May 2012 07:52 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, May 07, 2012 at 06:12:04PM +0530, Laxman Dewangan wrote:
>
>> Yaah, I should put the stylistic change at end..
>> I will send next patch for enabling cache and settling time.
>> Will keep discussion on stylistic changes and so will remove that
>> from this series.
> TBH I'd probably apply the style change if the regmap bit were using
> static inlines, though I'm not a big fan and wouldn't be happy with it
> in any consumer side code that I actively work on.

Actually I saw the multiple driver which uses set_bits()/clear_bits() 
and thought that this is good way of writing clean code and so developed 
multiple driver surrounding these apis.  Now seems it is easy for me to 
use these apis. May be it is my personal taste.

I will send the another patch making the function as static inline.

Thanks,
Laxman


