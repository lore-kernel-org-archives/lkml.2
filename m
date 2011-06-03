Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1FCCqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 22:46:07 -0400
Received: from mta11.charter.net ([216.33.127.80]:47248 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab1FCCqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 22:46:06 -0400
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=p9YancsnzTcA:10 a=9h0XS2p1Eb8A:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=wwRoC5N5CdDnPbExL-oA:9
 a=p9l3gT9Ygil6zE7pywcA:7 a=wPNLvfGTeEIA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DE84AE8.60109@cuw.edu>
Date: Thu, 02 Jun 2011 21:46:00 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
CC: malattia@linux.it, mjg@redhat.com, kernel-janitors@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sony-laptop: remove unused local variables
References: <1307068040-2918-1-git-send-email-Gregory.Dietsche@cuw.edu>
In-Reply-To: <1307068040-2918-1-git-send-email-Gregory.Dietsche@cuw.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please disregard... i neglected to rebase before sending. this patch no 
longer applies to the mainline.

Greg

On 06/02/2011 09:27 PM, Greg Dietsche wrote:
> Removed two unused instances of "handle" local variable.
>
> Signed-off-by: Greg Dietsche<Gregory.Dietsche@cuw.edu>
> ---
>   drivers/platform/x86/sony-laptop.c |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
> index 6fe8cd6..9a2c319 100644
> --- a/drivers/platform/x86/sony-laptop.c
> +++ b/drivers/platform/x86/sony-laptop.c
> @@ -961,7 +961,6 @@ static int sony_backlight_get_brightness(struct backlight_device *bd)
>   static int sony_nc_get_brightness_ng(struct backlight_device *bd)
>   {
>   	int result;
> -	int *handle = (int *)bl_get_data(bd);
>   	struct sony_backlight_props *sdev =
>   		(struct sony_backlight_props *)bl_get_data(bd);
>
> @@ -973,7 +972,6 @@ static int sony_nc_get_brightness_ng(struct backlight_device *bd)
>   static int sony_nc_update_status_ng(struct backlight_device *bd)
>   {
>   	int value, result;
> -	int *handle = (int *)bl_get_data(bd);
>   	struct sony_backlight_props *sdev =
>   		(struct sony_backlight_props *)bl_get_data(bd);
>
>    
