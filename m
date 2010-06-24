Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0FXXwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 19:52:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56700 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab0FXXwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 19:52:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NZIkA9VPwRmcfLDfuKF7AJ0Vk9XmOhyRacxQbOaUz2Kf7bYSKOz6gWUgKL/wcqCF/l
         oC0HCJb5ffIdQZrj/jvUzKmWbrqxgfsCSDgsGBUJWRVnpLDtSs0M7MpGy8quill8fyYU
         PGUYwpLOIo1VIXTTG2RBMTRCsIFDwseandtHg=
Message-ID: <4C23EFDE.3000702@lwfinger.net>
Date: Thu, 24 Jun 2010 18:53:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, mb@bu3sch.de, zajec5@gmail.com
Subject: Re: [PATCH net-next] MAINTAINERS: b43 updates
References: <cover.1276988387.git.joe@perches.com>	 <20100624185339.GC2368@tuxdriver.com>	 <1277408432.1654.80.camel@Joe-Laptop.home>  <4C23B877.4060209@lwfinger.net> <1277423102.1654.107.camel@Joe-Laptop.home>
In-Reply-To: <1277423102.1654.107.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 06:45 PM, Joe Perches wrote:
> On Thu, 2010-06-24 at 14:56 -0500, Larry Finger wrote:
>> The primary arbitrator for patches to the subtle parts of b43 is Michael
>> Buesch; however, he is no longer an official MAINTAINER. I can ACK some
>> things; however, any changes that are associated with my reverse
>> engineering of the Broadcom drivers are off limits.
> 
> Add Stefano Brivio's name and email address to CREDITS
> Removed Stefano Brivio's from B43 MAINTAINERS
> Added the b43 development mailing lists
> Changed B43 status to "Odd Fixes"
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  CREDITS     |    4 ++++
>  MAINTAINERS |    5 +++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/CREDITS b/CREDITS
> index 72b4878..30215f0 100644
> --- a/CREDITS
> +++ b/CREDITS
> @@ -495,6 +495,10 @@ S: Kopmansg 2
>  S: 411 13  Goteborg
>  S: Sweden
>  
> +N: Stefano Brivio
> +E: stefano.brivio@polimi.it
> +D: B43 wireless driver
> +
>  N: Paul Bristow
>  E: paul@paulbristow.net
>  W: http://paulbristow.net/linux/idefloppy.html
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6d119c9..5bc296c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1225,16 +1225,17 @@ F:	include/net/ax25.h
>  F:	net/ax25/
>  
>  B43 WIRELESS DRIVER
> -M:	Stefano Brivio <stefano.brivio@polimi.it>
>  L:	linux-wireless@vger.kernel.org
> +L:	b43-dev@lists.infradead.org
>  W:	http://linuxwireless.org/en/users/Drivers/b43
> -S:	Maintained
> +S:	Odd Fixes
>  F:	drivers/net/wireless/b43/
>  
>  B43LEGACY WIRELESS DRIVER
>  M:	Larry Finger <Larry.Finger@lwfinger.net>
>  M:	Stefano Brivio <stefano.brivio@polimi.it>
>  L:	linux-wireless@vger.kernel.org
> +L:	b43-dev@lists.infradead.org
>  W:	http://linuxwireless.org/en/users/Drivers/b43
>  S:	Maintained
>  F:	drivers/net/wireless/b43legacy/

NACK. I never said that b43 is unmaintained. It is definitely getting much
more than "odd fixes".

Larry
