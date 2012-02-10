Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab2BJMJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 07:09:19 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14930 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab2BJMJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 07:09:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 10 Feb 2012 04:09:17 -0800
Message-ID: <4F350886.4070600@nvidia.com>
Date: Fri, 10 Feb 2012 17:37:34 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] regmap: Support for caching in reg_raw_write()
References: <1328873572-12603-1-git-send-email-ldewangan@nvidia.com> <4F350716.9050407@metafoo.de>
In-Reply-To: <4F350716.9050407@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 February 2012 05:31 PM, Lars-Peter Clausen wrote:
> On 02/10/2012 12:32 PM, Laxman Dewangan wrote:
>> Adding support for caching of data into the
>> non-volatile register from the call of reg_raw_write().
>>
>> This will allow the larger block of data write into multiple
>> register without worrying whether register is cached or not
>> through reg_raw_write().
>>
> In my opinion it makes more sense to introduce a regmap_bulk_write function
> for this.
Yes, I am going to push another change which will have the 
regmap_bulk_write() which will be in sync with read part.

