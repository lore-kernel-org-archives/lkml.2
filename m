Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab2GLTWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 15:22:48 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45740 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab2GLTWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 15:22:44 -0400
Message-ID: <4FFF2403.5090809@kernel.org>
Date: Thu, 12 Jul 2012 20:22:43 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Gerard Snitselaar <dev@snitselaar.org>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-iio@vger.kernel.org, jic23@cam.ac.uk,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] iio: dac: ad5064: fix section mismatch in ad5064_init()
 in linux-next
References: <1341979502-27440-1-git-send-email-dev@snitselaar.org> <4FFD23BA.8070502@metafoo.de>
In-Reply-To: <4FFD23BA.8070502@metafoo.de>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 07:56 AM, Lars-Peter Clausen wrote:
> On 07/11/2012 06:05 AM, Gerard Snitselaar wrote:
>> ad5064_init() calls ad5064_spi_unregister_driver() which is annotated
>> __exit.
>>
>> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
> 
> Thanks,
> 
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>
merged to fixes-togreg and pull request sent.
> 
>> ---
>>  drivers/iio/dac/ad5064.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iio/dac/ad5064.c b/drivers/iio/dac/ad5064.c
>> index aa739c4..6ec1319 100644
>> --- a/drivers/iio/dac/ad5064.c
>> +++ b/drivers/iio/dac/ad5064.c
>> @@ -582,7 +582,7 @@ static int __init ad5064_spi_register_driver(void)
>>  	return spi_register_driver(&ad5064_spi_driver);
>>  }
>>  
>> -static void __exit ad5064_spi_unregister_driver(void)
>> +static void ad5064_spi_unregister_driver(void)
>>  {
>>  	spi_unregister_driver(&ad5064_spi_driver);
>>  }
> 


