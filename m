Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab2HPS4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:56:52 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:34188 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab2HPS4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:56:51 -0400
Message-ID: <502D4271.9080104@kernel.org>
Date: Thu, 16 Aug 2012 19:56:49 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Peter Meerwald <pmeerw@pmeerw.net>, Lars-Peter Clausen <lars@metafoo.de>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 1/3] iio: add iio_read_channel_offset() consumer api
References: <A874F61F95741C4A9BA573A70FE3998F41EEFD6E@DQHE02.ent.ti.com> <alpine.DEB.2.01.1208160940380.3550@pmeerw.net> <A874F61F95741C4A9BA573A70FE3998F41EEFDA0@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EEFDA0@DQHE02.ent.ti.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 08:49 AM, Kim, Milo wrote:
>>>  int iio_read_channel_scale(struct iio_channel *chan, int *val,
>>>  			   int *val2);
>>>
>>> +/**
>>> + * iio_read_channel_offset() - read offset from a given channel
>>> + * @channel:		The channel being queried.
>>
>> the parameter is 'chan', not 'channel'
>>
> 
> Oops, this is copy-and-paste disaster.
> The description of iio_read_channel_scale() also needs correction.
> Thanks for catching this !
good point.  Feel free to send a separate patch fixing that ;)
> 
> After getting other feedbacks, separate patch will be submitted.
> 
> Best Regards,
> Milo
> 
