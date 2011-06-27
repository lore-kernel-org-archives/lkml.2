Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1F0O5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:57:10 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:46128 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1F0O5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:57:07 -0400
Message-ID: <4E089A3D.7040201@ge.com>
Date: Mon, 27 Jun 2011 15:57:01 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: gef_wdt: fix MODULE_ALIAS
References: <1309185436.29085.3.camel@phoenix>
In-Reply-To: <1309185436.29085.3.camel@phoenix>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2011 14:54:33.0683 (UTC) FILETIME=[20549230:01CC34DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/11 15:37, Axel Lin wrote:
> Remove the space between "platform:" prefix and the driver name.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/watchdog/gef_wdt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
> index 29a7cd4..b146082 100644
> --- a/drivers/watchdog/gef_wdt.c
> +++ b/drivers/watchdog/gef_wdt.c
> @@ -329,4 +329,4 @@ MODULE_AUTHOR("Martyn Welch <martyn.welch@ge.com>");
>  MODULE_DESCRIPTION("GE watchdog driver");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> -MODULE_ALIAS("platform: gef_wdt");
> +MODULE_ALIAS("platform:gef_wdt");


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
