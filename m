Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1ILJFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 05:05:48 -0400
Received: from mail2.vodafone.ie ([213.233.128.44]:26076 "EHLO
	mail2.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab1ILJFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 05:05:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAJHKbU5tTEFC/2dsb2JhbAAMNapPAQEFMgFGEAsNAQoJFg8JAwIBAgFFBg0BBwEBvCmGbgSYcYMTiFY
Message-ID: <4E6DCB67.1060105@draigBrady.com>
Date: Mon, 12 Sep 2011 10:05:43 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Greg Lee <glee@swspec.com>
CC: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add WDIOC_GETTIMELEFT ioctl support to w83627 watchdog
 driver
References: <CADB-PD0N+tEC0H_iKzvV4Ms2snAJ3-+Lnk7tNF5=egAHdVuARQ@mail.gmail.com>
In-Reply-To: <CADB-PD0N+tEC0H_iKzvV4Ms2snAJ3-+Lnk7tNF5=egAHdVuARQ@mail.gmail.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/12/2011 06:10 AM, Greg Lee wrote:
> Add WDIOC_GETTIMELEFT ioctl allowing you to check how much time is left
> on the watchdog counter before a reset occurs.
> 
> Signed-off-by: Greg Lee <glee [at] swspec.com>
> 
> ---
> --- linux-3.1-rc5.orig/drivers/watchdog/w83627hf_wdt.c
> +++ linux-3.1-rc5.mine/drivers/watchdog/w83627hf_wdt.c
> @@ -176,6 +176,23 @@ static int wdt_set_heartbeat(int t)
>         return 0;
>  }
> 
> +static int wdt_get_time_left(void){

Thanks for this.

Please put the { on the next line.
s/wdt_ctrl/wdt_set_time/
s/wdt_get_time_left/wdt_get_time/

cheers,
Pádraig.
