Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1CZR3J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 13:29:09 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:57045 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753197Ab1CZR3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 13:29:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WsjAr11fFTNUFRsLWXxYY2sv+vpy2q3XjQEbnzBYIXxJCIpDmXVCIi9KICNt+T7tdgDRDaBBjaZfhXdAfDVi5lJCEb6FxDmP6x+LHyeh8dQF8Px2YFNnYGz1dWvc8Tu3;
Date: Sat, 26 Mar 2011 10:29:05 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sylvestre Ledru <sylvestre.ledru@scilab.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix some minor typos: * informations => information *
 there own => their own * an => and (bug #14973)
Message-Id: <20110326102905.bae3c800.rdunlap@xenotime.net>
In-Reply-To: <1301010464-22583-1-git-send-email-sylvestre.ledru@scilab.org>
References: <1301010464-22583-1-git-send-email-sylvestre.ledru@scilab.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011 00:47:44 +0100 Sylvestre Ledru wrote:

Hi,
This patch is mostly good, with a few exceptions as noted below.
Please resend a complete corrected patch.


> Signed-off-by: Sylvestre Ledru <sylvestre.ledru@scilab.org>
> ---
>  .../ABI/testing/sysfs-driver-hid-roccat-kone       |    2 +-
>  .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |    8 ++++----
>  .../ABI/testing/sysfs-driver-hid-roccat-kovaplus   |    8 ++++----
>  .../ABI/testing/sysfs-driver-hid-roccat-pyra       |    8 ++++----
>  .../ABI/testing/sysfs-platform-asus-laptop         |    2 +-
>  Documentation/devicetree/booting-without-of.txt    |    6 +++---
>  Documentation/dvb/udev.txt                         |    2 +-
>  Documentation/edac.txt                             |    2 +-
>  Documentation/kernel-parameters.txt                |    4 ++--
>  Documentation/laptops/asus-laptop.txt              |    4 ++--
>  Documentation/networking/batman-adv.txt            |    2 +-
>  Documentation/s390/Debugging390.txt                |    2 +-
>  Documentation/scsi/sym53c8xx_2.txt                 |    2 +-
>  Documentation/sound/alsa/ALSA-Configuration.txt    |    2 +-
>  Documentation/sound/oss/AudioExcelDSP16            |    6 +++---
>  Documentation/sound/oss/README.ymfsb               |    2 +-
>  Documentation/video4linux/bttv/Insmod-options      |    2 +-
>  Documentation/video4linux/bttv/Sound-FAQ           |    2 +-
>  Documentation/video4linux/et61x251.txt             |    4 ++--
>  Documentation/video4linux/sn9c102.txt              |    4 ++--
>  Documentation/video4linux/w9968cf.txt              |    2 +-
>  Documentation/video4linux/zc0301.txt               |    6 +++---
>  arch/powerpc/mm/tlb_low_64e.S                      |    2 +-
>  arch/powerpc/platforms/Kconfig                     |    2 +-
>  fs/notify/fanotify/Kconfig                         |    2 +-
>  25 files changed, 44 insertions(+), 44 deletions(-)


> diff --git a/Documentation/ABI/testing/sysfs-platform-asus-laptop b/Documentation/ABI/testing/sysfs-platform-asus-laptop
> index 41ff8ae..01160d8 100644
> --- a/Documentation/ABI/testing/sysfs-platform-asus-laptop
> +++ b/Documentation/ABI/testing/sysfs-platform-asus-laptop
> @@ -27,7 +27,7 @@ KernelVersion:	2.6.20
>  Contact:	"Corentin Chary" <corentincj@iksaif.net>
>  Description:
>  		Some models like the W1N have a LED display that can be

		                              an

> -		used to display several informations.
> +		used to display several information.

Either way is awkward.  Needs something more like:

		used to display several items of information.


>  		To control the LED display, use the following :
>  		    echo 0x0T000DDD > /sys/devices/platform/asus_laptop/
>  		where T control the 3 letters display, and DDD the 3 digits display.

> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index d18a9e1..29ac507 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2463,8 +2463,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	topology=	[S390]
>  			Format: {off | on}
>  			Specify if the kernel should make use of the cpu
> -			topology informations if the hardware supports these.
> -			The scheduler will make use of these informations and
> +			topology information if the hardware supports these.

s/these/this/ just as was done below.

> +			The scheduler will make use of this information and
>  			e.g. base its process migration decisions on it.
>  			Default is on.
>  
> diff --git a/Documentation/laptops/asus-laptop.txt b/Documentation/laptops/asus-laptop.txt
> index c1c5be8..90d8b86 100644
> --- a/Documentation/laptops/asus-laptop.txt
> +++ b/Documentation/laptops/asus-laptop.txt
> @@ -178,7 +178,7 @@ LED display
>  -----------
>  
>    Some models like the W1N have a LED display that can be used to display
> -  several informations.
> +  several information.

Same comment as above.

>  
>    LED display works for the following models:
>      W1000N

> diff --git a/fs/notify/fanotify/Kconfig b/fs/notify/fanotify/Kconfig
> index 7dceff0..30dc09c 100644
> --- a/fs/notify/fanotify/Kconfig
> +++ b/fs/notify/fanotify/Kconfig
> @@ -6,7 +6,7 @@ config FANOTIFY
>  	---help---
>  	   Say Y here to enable fanotify suport.  fanotify is a file access
>  	   notification system which differs from inotify in that it sends
> -	   an open file descriptor to the userspace listener along with
> +	   and opens file descriptor to the userspace listener along with

Nope, "an open" is correct.

>  	   the event.
>  
>  	   If unsure, say Y.
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
