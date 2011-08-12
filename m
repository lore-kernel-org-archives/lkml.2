Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1HLIni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:43:38 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:54041 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1HLIng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:43:36 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E44E99E.3070302@cam.ac.uk>
Date: Fri, 12 Aug 2011 09:51:42 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110801 Thunderbird/5.0
MIME-Version: 1.0
To: stufever@gmail.com
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, gregkh@suse.de,
        michael.hennerich@analog.com, Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: Re: [PATCH] staging: IIO: DAC: Delete useless label error_ret in
 ad5791.c
References: <1312654158-28057-1-git-send-email-wangshaoyan.pt@taobao.com>
In-Reply-To: <1312654158-28057-1-git-send-email-wangshaoyan.pt@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/11 19:09, stufever@gmail.com wrote:
> From: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> 
>   drivers/staging/iio/dac/ad5791.c: In function 'ad5791_probe':
>   drivers/staging/iio/dac/ad5791.c:384: warning: label 'error_ret' defined but not used
> 
> The label error_ret is defined, but never used, so delete it to avoid annoying warning.
As with other one, this is fixed in iio-blue.git, but I'm happy to see either version merge.
> 
> Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/staging/iio/dac/ad5791.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/iio/dac/ad5791.c b/drivers/staging/iio/dac/ad5791.c
> index 64770d2..5b00b70 100644
> --- a/drivers/staging/iio/dac/ad5791.c
> +++ b/drivers/staging/iio/dac/ad5791.c
> @@ -381,7 +381,6 @@ error_put_reg_pos:
>  	if (!IS_ERR(reg_vdd))
>  		regulator_put(reg_vdd);
>  
> -error_ret:
>  	return ret;
>  }
>  

