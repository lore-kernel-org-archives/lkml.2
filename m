Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935Ab0J0La7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:30:59 -0400
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:38114 "EHLO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791Ab0J0La5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:30:57 -0400
Message-ID: <4CC80D20.5060504@ge.com>
Date: Wed, 27 Oct 2010 12:29:36 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 13/30] staging/vme_user: declare private variables as
 static
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-14-git-send-email-cota@braap.org>
In-Reply-To: <1288055476-19438-14-git-send-email-cota@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 11:30:54.0293 (UTC) FILETIME=[6AA06050:01CB75CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/10 02:10, Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> Signed-off-by: Emilio G. Cota <cota@braap.org>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/devices/vme_user.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
> index bdc4e1e..31a74e2 100644
> --- a/drivers/staging/vme/devices/vme_user.c
> +++ b/drivers/staging/vme/devices/vme_user.c
> @@ -114,9 +114,9 @@ typedef struct {
>  } driver_stats_t;
>  static driver_stats_t statistics;
>  
> -struct cdev *vme_user_cdev;		/* Character device */
> -struct class *vme_user_sysfs_class;	/* Sysfs class */
> -struct device *vme_user_bridge;		/* Pointer to the bridge device */
> +static struct cdev *vme_user_cdev;		/* Character device */
> +static struct class *vme_user_sysfs_class;	/* Sysfs class */
> +static struct device *vme_user_bridge;		/* Pointer to the bridge device */
>  
>  
>  static const int type[VME_DEVS] = {	MASTER_MINOR,	MASTER_MINOR,


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
