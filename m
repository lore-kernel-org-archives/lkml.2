Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0HPR4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:56:03 -0400
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:50605 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab0HPR4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:56:01 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2010 13:56:01 EDT
Message-ID: <4C6979CC.80107@adurom.com>
Date: Mon, 16 Aug 2010 20:47:56 +0300
From: Kalle Valo <kvalo@adurom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/16] drivers/net/wireless/wl12xx: Use available error
 codes
References: <Pine.LNX.4.64.1008161825010.19313@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1008161825010.19313@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2010 07:25 PM, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In each case, error codes are stored in ret, but the return value is always
> 0.  Return ret instead.

Thanks, looks correct to me.

Acked-by: Kalle Valo <kvalo@adurom.com>

Kalle
