Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212Ab2DLNUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:20:44 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12098 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934170Ab2DLNUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:20:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 12 Apr 2012 06:20:33 -0700
Message-ID: <4F86D3ED.4020301@nvidia.com>
Date: Thu, 12 Apr 2012 18:39:01 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "jbrenner@taosinc.com" <jbrenner@taosinc.com>,
        Rhyland Klein <rklein@nvidia.com>, "max@stro.at" <max@stro.at>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH V3 1/2] staging: iio: add channel info for sampling frequency
References: <1334234288-25037-1-git-send-email-ldewangan@nvidia.com> <1334234288-25037-2-git-send-email-ldewangan@nvidia.com> <4F86D55F.2030808@cam.ac.uk>
In-Reply-To: <4F86D55F.2030808@cam.ac.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2012 06:45 PM, Jonathan Cameron wrote:
> On 4/12/2012 1:38 PM, Laxman Dewangan wrote:
>> Adding channel info IIO_CHAN_INFO_SAMP_FREQ to select
>> different sampling frequency per channel wise.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>> ---
>> As per discussion on previous patch, adding channel info
>> for selecting sampling freqeuncy.
> To match with the existing devices can we not use the abrieviation
> for the attribute naming.
>

Sorry..I did not get it completely.
Is it like we should have IIO_CHAN_INFO_SAMPLING_FREQUENCY in place of  
IIO_CHAN_INFO_SAMP_FREQ?


>> @@ -90,6 +90,7 @@ static const char * const iio_chan_info_postfix[] = {
>>    	[IIO_CHAN_INFO_AVERAGE_RAW] = "mean_raw",
>>    	[IIO_CHAN_INFO_LOW_PASS_FILTER_3DB_FREQUENCY]
>>    	= "filter_low_pass_3db_frequency",
>> +	[IIO_CHAN_INFO_SAMP_FREQ] = "samp_freq",
> "sampling_frequency"

and then change here as "sampling_frequency"?



