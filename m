Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab0CaMMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 08:12:34 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51422 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311Ab0CaMMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 08:12:23 -0400
Message-ID: <4BB33C06.1040307@canonical.com>
Date: Wed, 31 Mar 2010 20:11:50 +0800
From: Bryan Wu <bryan.wu@canonical.com>
Reply-To: bryan.wu@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100322 Thunderbird/3.0.3
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>,
       Sascha Hauer <s.hauer@pengutronix.de>
CC: gerg@uclinux.org, amit.kucheria@canonical.com,
       kernel-team@lists.ubuntu.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] netdev/fec.c: add phylib supporting to enable carrier
 detection
References: <1269597052-10104-1-git-send-email-bryan.wu@canonical.com> <20100331075746.GO2241@pengutronix.de> <20100331081004.GB23391@pengutronix.de>
In-Reply-To: <20100331081004.GB23391@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 04:10 PM, Wolfram Sang wrote:
>> With rounding this would be:
>>
>> (clk_get_rate() + 4999999) / 5000000
>
> Better use DIV_ROUND_UP(clk_get_rate(), 5000000)?
>
> Regards,
>
>     Wolfram
>

Sascha and Wolfram,

Thanks a lot. I updated the patch to v2 and sent it already.

-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu Kernel Team | Hardware Enablement Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
