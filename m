Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab0HJPcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:32:35 -0400
Received: from compulab.co.il ([67.18.134.219]:37011 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0HJPcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:32:31 -0400
Message-ID: <4C6170FB.9080609@compulab.co.il>
Date: Tue, 10 Aug 2010 18:32:11 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: tps6586x - add regulator_unregister() in tps6586x_regulator_remove()
References: <1281340686.20518.4.camel@mola> <20100810150052.GK6416@rakim.wolfsonmicro.main>
In-Reply-To: <20100810150052.GK6416@rakim.wolfsonmicro.main>
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
> On Mon, Aug 09, 2010 at 03:58:06PM +0800, Axel Lin wrote:
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Mike Rapoport <mike@compulab.co.il>

> 
>>  
>> -	platform_set_drvdata(pdev, ri);
>> +	platform_set_drvdata(pdev, rdev);
>>  
> 
> This would've been easier to review if you'd mentioned in the changelog
> that there were no users of the current platform data, just to show that
> you'd checked.


-- 
Sincerely yours,
Mike.
