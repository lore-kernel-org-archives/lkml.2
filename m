Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1LIJSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:18:08 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4663 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab1LIJSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:18:05 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4EE1D239.8000302@broadcom.com>
Date: Fri, 9 Dec 2011 10:17:45 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124
 Thunderbird/8.0
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH 6/8] MAINTAINERS: brcm80211: Update F: pattern
References: <cover.1323418149.git.joe@perches.com>
 <4dac2c8b01628a8875dfd2f9b87fa3135bb46e62.1323418149.git.joe@perches.com>
In-Reply-To: <4dac2c8b01628a8875dfd2f9b87fa3135bb46e62.1323418149.git.joe@perches.com>
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 62FF0C705043173455-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2011 09:12 AM, Joe Perches wrote:
> commit fc2d6e573be
> ("staging: brcm80211: remove brcm80211 driver from the staging tree")
> moved the files, update the F: pattern.
> 
> CC: John W. Linville <linville@tuxdriver.com>
> CC: Arend van Spriel <arend@broadcom.com>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b40e522..dd083d2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1590,7 +1590,7 @@ M:	Franky (Zhenhui) Lin <frankyl@broadcom.com>
>  M:	Kan Yan	<kanyan@broadcom.com>
>  L:	linux-wireless@vger.kernel.org
>  S:	Supported
> -F:	drivers/staging/brcm80211/
> +F:	drivers/net/wireless/brcm80211/
>  
>  BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER
>  M:	Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Overlooked that one. Thanks, Joe

Gr. AvS

