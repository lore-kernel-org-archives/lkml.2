Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab1GFThx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:37:53 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:48696 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab1GFThv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:37:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E14BB6C.9040804@cam.ac.uk>
Date: Wed, 06 Jul 2011 20:45:48 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de, rklein@nvidia.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 2/3] staging:iio: Add an iio channel type string to support
 proximity sensors.
References: <1309978586-10092-1-git-send-email-bfreed@chromium.org> <1309978586-10092-2-git-send-email-bfreed@chromium.org>
In-Reply-To: <1309978586-10092-2-git-send-email-bfreed@chromium.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/11 19:56, Bryan Freed wrote:
> Add "proximity" to the iio_chan_type_name_spec_shared string list to
> support proximity sensors.
> Now this list fully matches the declared iio_chan_type enums.
> 
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/staging/iio/industrialio-core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
> index 4987bf4..ef9a11e 100644
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -53,6 +53,7 @@ static const char * const iio_chan_type_name_spec_shared[] = {
>  	[IIO_MAGN] = "magn",
>  	[IIO_LIGHT] = "illuminance",
>  	[IIO_INTENSITY] = "intensity",
> +	[IIO_PROXIMITY] = "proximity",
>  	[IIO_TEMP] = "temp",
>  	[IIO_INCLI] = "incli",
>  	[IIO_ROT] = "rot",

