Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab1J1Lt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:49:59 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:60551 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932427Ab1J1Lt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:49:59 -0400
Message-ID: <4EAA96E0.7060904@ti.com>
Date: Fri, 28 Oct 2011 17:19:52 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Shubhrajyoti D <shubhrajyoti@ti.com>
CC: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] OMAP: SPI: Driver updates
References: <1319802115-16499-1-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1319802115-16499-1-git-send-email-shubhrajyoti@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 October 2011 05:11 PM, Shubhrajyoti D wrote:
> The patch series does the following
> 1. Optimises the workqueue to have 1 workqueue per controller so
>   that one data of one queue doesnt interfere with other.
>   Earlier discussion thread
>
> http://sourceforge.net/mailarchive/forum.php?thread_name=1319210705-18677-1-git-send-email-shubhrajyoti%40ti.com&forum_name=spi-devel-general
>
> 2. Call pm_runtime_disable as it got missed out.
> 3. Error handling in the spi driver is corrected.
Apologies got sent twice please ignore
>
> Shubhrajyoti D (3):
>    OMAP: SPI: Use a workqueue per omap2_mcspi controller
>    OMAP: SPI: call pm_runtime_disable in error path and remove
>    OMAP: SPI: Correct the error path
>
>   drivers/spi/spi-omap2-mcspi.c |   51 +++++++++++++++++++++++++---------------
>   1 files changed, 32 insertions(+), 19 deletions(-)
>

