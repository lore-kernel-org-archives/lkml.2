Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab1JRNQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:16:41 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:58879 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab1JRNQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:16:39 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9D7C3A.1020309@cam.ac.uk>
Date: Tue, 18 Oct 2011 14:16:42 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 7/7] input/cma3000_d0x: Match comment to name of struct
References: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com> <1318939596-27330-8-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1318939596-27330-8-git-send-email-ricardo.ribalda@gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/11 13:06, Ricardo Ribalda Delgado wrote:
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  include/linux/input/cma3000.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/input/cma3000.h b/include/linux/input/cma3000.h
> index cbbaac2..e8c28e8 100644
> --- a/include/linux/input/cma3000.h
> +++ b/include/linux/input/cma3000.h
> @@ -33,7 +33,7 @@
>  #define CMARANGE_8G   8000
>  
>  /**
> - * struct cma3000_i2c_platform_data - CMA3000 Platform data
> + * struct cma3000_platform_data - CMA3000 Platform data
>   * @fuzz_x: Noise on X Axis
>   * @fuzz_y: Noise on Y Axis
>   * @fuzz_z: Noise on Z Axis

