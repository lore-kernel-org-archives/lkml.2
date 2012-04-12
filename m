Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223Ab2DLNVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:21:43 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:36670 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183Ab2DLNVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:21:42 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F86D6DF.40704@cam.ac.uk>
Date: Thu, 12 Apr 2012 14:21:35 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
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
References: <1334234288-25037-1-git-send-email-ldewangan@nvidia.com> <1334234288-25037-2-git-send-email-ldewangan@nvidia.com> <4F86D55F.2030808@cam.ac.uk> <4F86D3ED.4020301@nvidia.com>
In-Reply-To: <4F86D3ED.4020301@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 2:09 PM, Laxman Dewangan wrote:
> On Thursday 12 April 2012 06:45 PM, Jonathan Cameron wrote:
>> On 4/12/2012 1:38 PM, Laxman Dewangan wrote:
>>> Adding channel info IIO_CHAN_INFO_SAMP_FREQ to select
>>> different sampling frequency per channel wise.
>>>
>>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>>> ---
>>> As per discussion on previous patch, adding channel info
>>> for selecting sampling freqeuncy.
>> To match with the existing devices can we not use the abrieviation
>> for the attribute naming.
>>
>
> Sorry..I did not get it completely.
> Is it like we should have IIO_CHAN_INFO_SAMPLING_FREQUENCY in place 
> of  IIO_CHAN_INFO_SAMP_FREQ?
SAMP_FREQ is fine internally.
>
>
>>> @@ -90,6 +90,7 @@ static const char * const iio_chan_info_postfix[] = {
>>>        [IIO_CHAN_INFO_AVERAGE_RAW] = "mean_raw",
>>>        [IIO_CHAN_INFO_LOW_PASS_FILTER_3DB_FREQUENCY]
>>>        = "filter_low_pass_3db_frequency",
>>> +    [IIO_CHAN_INFO_SAMP_FREQ] = "samp_freq",
>> "sampling_frequency"
>
> and then change here as "sampling_frequency"?
>
Yup, that's the one that is (in the general all channels case) already 
in the abi docs...
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

