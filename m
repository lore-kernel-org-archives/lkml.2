Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab2HWDBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 23:01:06 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36361 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab2HWDBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 23:01:03 -0400
Date: Wed, 22 Aug 2012 19:58:24 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Add new power supply AUTHENTIC property
Message-ID: <20120823025821.GA12673@lizard>
References: <1345684821-13890-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1345684821-13890-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 06:50:21AM +0530, Ramakrishna Pallala wrote:
> It is possible that users can use non-standard chargers
> or use invalid batteries especially with mobile devices.
> 
> This patch adds a new power supply property called 'AUTHENTIC' to
> indicate this to the user(user space).
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---

Applied, thanks a lot!

>  Documentation/power/power_supply_class.txt |    3 +++
>  drivers/power/power_supply_sysfs.c         |    1 +
>  include/linux/power_supply.h               |    1 +
>  3 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
> index 2f0ddc1..29a1fcd 100644
> --- a/Documentation/power/power_supply_class.txt
> +++ b/Documentation/power/power_supply_class.txt
> @@ -81,6 +81,9 @@ This defines trickle and fast charges.  For batteries that
>  are already charged or discharging, 'n/a' can be displayed (or
>  'unknown', if the status is not known).
>  
> +AUTHENTIC - indicates the power supp(battery or charger) connected

Had to fix s/supp/supply/
