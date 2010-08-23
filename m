Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab0HWKJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:09:56 -0400
Received: from compulab.co.il ([67.18.134.219]:54113 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab0HWKJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:09:54 -0400
Message-ID: <4C7248C3.9040304@compulab.co.il>
Date: Mon, 23 Aug 2010 13:09:07 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Gary King <gking@nvidia.com>
CC: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 2/2] regulator: tps6586x-regulator - fix bit_mask parameter
 for tps6586x_set_bits()
References: <1282487895.23014.19.camel@phoenix> <1282488162.23014.24.camel@phoenix> <20100823100248.GG6061@rakim.wolfsonmicro.main>
In-Reply-To: <20100823100248.GG6061@rakim.wolfsonmicro.main>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Sun, Aug 22, 2010 at 10:42:42PM +0800, Axel Lin wrote:
>> The third parameter of tps6586x_set_bits() is the bit_mask,
>> thus we should use (1 << ri->go_bit) instead of ri->go_bit.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> but I'd be much happier if someone who actually has the hardware could
> verify that this is OK.

I don't have the hardware handy at the moment.
Gary, can you please verify the fix?

-- 
Sincerely yours,
Mike.
