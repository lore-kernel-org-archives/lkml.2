Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab1EZJGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:06:38 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:33852 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467Ab1EZJGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:06:36 -0400
Subject: Re: [PATCH][Trivial] mac80211: Remove duplicate linux/slab.h
 include from net/mac80211/scan.c
From: Luciano Coelho <coelho@ti.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, trivial@kernel.org
In-Reply-To: <alpine.LNX.2.00.1105261048570.17400@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1105261048570.17400@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 12:06:31 +0300
Message-ID: <1306400791.19876.41.camel@cumari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 10:53 +0200, Jesper Juhl wrote: 
> Commit 79f460ca49d8d5700756ab7071c951311c7f29cc add a duplicate 
> linux/slab.h include to net/mac80211/scan.c - remove it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---

Hmmm... indeed! Must have been a rebase mistake I made.  Thanks for
fixing it.

Acked-by: Luciano Coelho <coelho@ti.com>


-- 
Cheers,
Luca.

