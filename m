Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab1HLFUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 01:20:35 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:45249 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930Ab1HLFUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 01:20:33 -0400
Subject: Re: [PATCH 2/9] drivers/net/wireless/wl12xx: add missing kfree
From: Luciano Coelho <coelho@ti.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia@diku.dk>
In-Reply-To: <1312802283-9107-2-git-send-email-julia@diku.dk>
References: <1312802283-9107-2-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 08:14:01 +0300
Message-ID: <1313126041.2407.911.camel@cumari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 13:17 +0200, Julia Lawall wrote: 
> From: Julia Lawall <julia@diku.dk>
> 
> In each case, the freed data should be freed in the error handling code as
> well.

[...]

> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---

John, since you took Julia's patch for wl1251 into 3.1, could you also
take this patch into it, please?

Acked-by: Luciano Coelho <coelho@ti.com>

-- 
Cheers,
Luca.

