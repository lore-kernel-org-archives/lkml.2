Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953Ab0J0LbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:31:16 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:44167 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab0J0LbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:31:15 -0400
Message-ID: <4CC80D33.1050009@ge.com>
Date: Wed, 27 Oct 2010 12:29:55 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 14/30] staging/vme_user: use an unsigned int for counting
 the number of kparams
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-15-git-send-email-cota@braap.org>
In-Reply-To: <1288055476-19438-15-git-send-email-cota@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 11:31:13.0261 (UTC) FILETIME=[75EEA9D0:01CB75CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/10 02:11, Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> unsigned int is what struct kparam_array internally uses.
> 
> Signed-off-by: Emilio G. Cota <cota@braap.org>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/devices/vme_user.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
> index 31a74e2..e7669a4 100644
> --- a/drivers/staging/vme/devices/vme_user.c
> +++ b/drivers/staging/vme/devices/vme_user.c
> @@ -44,7 +44,7 @@ static DEFINE_MUTEX(vme_user_mutex);
>  static char driver_name[] = "vme_user";
>  
>  static int bus[USER_BUS_MAX];
> -static int bus_num;
> +static unsigned int bus_num;
>  
>  /* Currently Documentation/devices.txt defines the following for VME:
>   *


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
