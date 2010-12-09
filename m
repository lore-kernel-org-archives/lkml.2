Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab0LIMBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 07:01:20 -0500
Received: from mail.atheros.com ([12.19.149.2]:22632 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700Ab0LIMBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 07:01:19 -0500
Message-ID: <4D00C505.7040500@atheros.com>
Date: Thu, 9 Dec 2010 17:31:09 +0530
From: Bala Shanmugam <sbalashanmugam@atheros.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Shanmugamkamatchi Balashanmugam 
	<Shanmugamkamatchi.Balashanmugam@atheros.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath3k-fw: Fix EEPROM radio table issue.
References: <1291367907-3650-1-git-send-email-sbalashanmugam@atheros.com>
In-Reply-To: <1291367907-3650-1-git-send-email-sbalashanmugam@atheros.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/3/2010 2:48 PM, Shanmugamkamatchi Balashanmugam wrote:
> Updated PID value to 3005 for devices with
> sflash firmware.
>
> Signed-off-by: Bala Shanmugam<sbalashanmugam@atheros.com>
> ---
>   WHENCE     |    2 ++
>   ath3k-1.fw |  Bin 246804 ->  246804 bytes
>   2 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/WHENCE b/WHENCE
> index 907fe68..0e3468f 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1101,6 +1101,8 @@ Driver: ath3k - DFU Driver for Atheros bluetooth chipset AR3011
>   File: ath3k-1.fw
>   Info: v1.0
>
> +Fix EEPROM radio table issue and change PID to 3005
> +
>   Licence: Redistributable. See LICENCE.atheros_firmware for details
>
>   --------------------------------------------------------------------------
> diff --git a/ath3k-1.fw b/ath3k-1.fw
> index 4a5ffb8de898fab1595662742f287493689e2b3b..63aa9b9ad87d3d918e441d921ada9cad08687ae5 100644
> GIT binary patch
> delta 129491
>
David,

We have upstreamed the transport driver changes.
We need this firmware upstreamed soon for our chip to work.

Do you have any comments on this patch?

Regards,
Bala.
