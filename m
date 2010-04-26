Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab0DZInM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 04:43:12 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:41166 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0DZInK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 04:43:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BD552CC.3000107@jic23.retrosnub.co.uk>
Date: Mon, 26 Apr 2010 09:46:04 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Barry Song <21cnbao@gmail.com>
CC: jic23@cam.ac.uk, gregkh@suse.de, linux-iio@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: fix typo in userspace example codes and document
References: <1272255541-11835-1-git-send-email-21cnbao@gmail.com>
In-Reply-To: <1272255541-11835-1-git-send-email-21cnbao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/10 05:19, Barry Song wrote:
> Signed-off-by: Barry Song <21cnbao@gmail.com>
Thanks Barry.  Ironically I rewrote this example yesterday to match the new
abi (though I hadn't noticed the documentation error!).
Still worth merging this as it may be a little while before everyone
is happy with that patch set. Will hopefully post a new revision of that
later today.

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  .../iio/Documentation/lis3l02dqbuffersimple.c      |    2 +-
>  drivers/staging/iio/Documentation/userspace.txt    |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c b/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
> index 2b5cfc5..811dd14 100644
> --- a/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
> +++ b/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
> @@ -20,7 +20,7 @@
>  
>  #include <linux/types.h>
>  #include <dirent.h>
> -#include "iio_util.h"
> +#include "iio_utils.h"
>  
>  static const char *ring_access = "/dev/iio/lis3l02dq_ring_access";
>  static const char *ring_event = "/dev/iio/lis3l02dq_ring_event";
> diff --git a/drivers/staging/iio/Documentation/userspace.txt b/drivers/staging/iio/Documentation/userspace.txt
> index 661015a..4838818 100644
> --- a/drivers/staging/iio/Documentation/userspace.txt
> +++ b/drivers/staging/iio/Documentation/userspace.txt
> @@ -56,5 +56,5 @@ KERNEL="ring_event_line*", ID="spi1.0", DRIVER="lis3l02dq", NAME="iio/lis3l02dq_
>  KERNEL="event_line*", ID="spi1.0", DRIVER="lis3l02dq", NAME="iio/lis3l02dq_event"
>  KERNEL="ring_access*", ID="spi1.0", DRIVER="lis3l02dq", NAME="iio/lis3l02dq_ring_access"
>  
> -The files, lis3l02dqbuffersimple.c and iio_util.h in this directory provide an example
> +The files, lis3l02dqbuffersimple.c and iio_utils.h in this directory provide an example
>  of how to use the ring buffer and event interfaces.

