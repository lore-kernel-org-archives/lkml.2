Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207Ab1HMFws (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 01:52:48 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:52480 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750791Ab1HMFwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 01:52:47 -0400
Subject: Re: [PATCH 3/4]drivers:staging Fix typo "shud"
From: Joe Perches <joe@perches.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1313195174-4464-3-git-send-email-justinmattock@gmail.com>
References: <1313195174-4464-1-git-send-email-justinmattock@gmail.com>
	 <1313195174-4464-3-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 22:52:44 -0700
Message-ID: <1313214765.1698.4.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 17:26 -0700, Justin P. Mattock wrote:
> From: "Justin P. Mattock" <justinmattock@gmail.com>
> The patch below fixes a typo shud.
>  drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    2 +-
> diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
[]
> @@ -1934,7 +1934,7 @@ ar6000_stop_endpoint(struct net_device *dev, bool keepprofile, bool getdbglogs)
[]
> -             * After wmi_shudown all WMI events will be dropped.
> +             * After wmi_shutown all WMI events will be dropped.

Please use a spell checker or read your patches after
auto generating them.

shutdown

Patch 4 as the same spelling typo.
Patch 2 has a leet speek use of l8r you could fix too.

