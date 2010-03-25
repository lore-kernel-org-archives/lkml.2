Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab0CYSHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:07:09 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:46062 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab0CYSHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:07:06 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BABA6DD.7020403@cam.ac.uk>
Date: Thu, 25 Mar 2010 18:09:33 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Andrea Gelmini <andrea.gelmini@gelma.net>
CC: linux-doc@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 06/16] Staging: iio: Documentation/lis3l02dqbuffersimple.c:
 duplicated include
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net> <1269537767-7553-7-git-send-email-andrea.gelmini@gelma.net>
In-Reply-To: <1269537767-7553-7-git-send-email-andrea.gelmini@gelma.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/10 17:22, Andrea Gelmini wrote:
> drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c: dirent.h is included more than once.
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
Fair point.

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  .../iio/Documentation/lis3l02dqbuffersimple.c      |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c b/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
> index 2b5cfc5..6a8fa0c 100644
> --- a/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
> +++ b/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
> @@ -19,7 +19,6 @@
>  #include <sys/dir.h>
>  
>  #include <linux/types.h>
> -#include <dirent.h>
>  #include "iio_util.h"
>  
>  static const char *ring_access = "/dev/iio/lis3l02dq_ring_access";

