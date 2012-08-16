Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab2HPIZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:25:34 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:42875 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756449Ab2HPIZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:25:30 -0400
Message-ID: <502CAE74.7060808@metafoo.de>
Date: Thu, 16 Aug 2012 10:25:24 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@kernel.org>, "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 1/3] iio: add iio_read_channel_offset() consumer api
References: <A874F61F95741C4A9BA573A70FE3998F41EEFD6E@DQHE02.ent.ti.com> <502CACFF.3000105@metafoo.de>
In-Reply-To: <502CACFF.3000105@metafoo.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 10:19 AM, Lars-Peter Clausen wrote:
> On 08/16/2012 09:39 AM, Kim, Milo wrote:
>> This allows the iio consumer to get the offset of the channel.
>> The value of offset can be used when calculating the result such
>> as 'result = raw * scale + offset'.
> 
> result = (raw + offset) * scale
> 
> Otherwise it looks good, except for:
> 
>> +/**
>> + * iio_read_channel_offset() - read offset from a given channel
>> + * @channel:		The channel being queried.
>> + * @val:		Offset Value read back.
>> + *
>> + * Note offset can be used in the consumer when calculating the result
>> + * such as 'result = raw * scale + offset'.
>> + */
> 
> The documentation should go in the c file.

Just saw that for the other functions in consumer.h it is in the header as
well, so ignore that comment above.

> 
>> +int iio_read_channel_offset(struct iio_channel *chan, int *val);
>>  #endif
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

