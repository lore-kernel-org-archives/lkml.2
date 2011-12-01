Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab1LASrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:47:33 -0500
Received: from void.printf.net ([89.145.121.20]:49347 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab1LASrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:47:31 -0500
From: Chris Ball <cjb@laptop.org>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, Alex Dubov <oakad@yahoo.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 20/62] mmc: remove the second argument of k[un]map_atomic()
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
	<1322371662-26166-21-git-send-email-amwang@redhat.com>
Date: Thu, 01 Dec 2011 13:47:12 -0500
In-Reply-To: <1322371662-26166-21-git-send-email-amwang@redhat.com> (Cong
	Wang's message of "Sun, 27 Nov 2011 13:27:00 +0800")
Message-ID: <87vcq0jfin.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Nov 27 2011, Cong Wang wrote:
> Signed-off-by: Cong Wang <amwang@redhat.com>
> ---
>  drivers/mmc/host/at91_mci.c |    8 ++++----
>  drivers/mmc/host/msm_sdcc.c |    6 +++---
>  drivers/mmc/host/sdhci.c    |    4 ++--
>  drivers/mmc/host/tifm_sd.c  |   16 ++++++++--------
>  drivers/mmc/host/tmio_mmc.c |    1 -
>  drivers/mmc/host/tmio_mmc.h |    4 ++--
>  6 files changed, 19 insertions(+), 20 deletions(-)

Looks good, thanks, pushed to mmc-next for 3.3.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
