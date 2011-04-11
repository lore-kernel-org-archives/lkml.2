Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1DKSmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 14:42:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:15096 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849Ab1DKSmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 14:42:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,192,1301900400"; 
   d="scan'208";a="677705424"
Subject: Re: [PATCH] iwlegacy: make iwl3945 and iwl4965 select
 IWLWIFI_LEGACY
From: wwguy <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
In-Reply-To: <1302541599-15383-1-git-send-email-linville@tuxdriver.com>
References: <BANLkTimoDVMcvFdoUedyfw4Thv8=DsV-5A@mail.gmail.com>
	 <1302541599-15383-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Apr 2011 11:39:22 -0700
Message-ID: <1302547162.5663.2.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 10:06 -0700, John W. Linville wrote:
> Otherwise, IWLWIFI_LEGACY has to be selected independently before the
> drivers are made available.
> 
> Reported-by: Dave Airlie <airlied@gmail.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlegacy/Kconfig |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlegacy/Kconfig b/drivers/net/wireless/iwlegacy/Kconfig
> index 2a45dd4..aef65cd 100644
> --- a/drivers/net/wireless/iwlegacy/Kconfig
> +++ b/drivers/net/wireless/iwlegacy/Kconfig
> @@ -1,6 +1,5 @@
>  config IWLWIFI_LEGACY
> -	tristate "Intel Wireless Wifi legacy devices"
> -	depends on PCI && MAC80211
> +	tristate
>  	select FW_LOADER
>  	select NEW_LEDS
>  	select LEDS_CLASS

Should we add some ---help--- here?, or not..

Wey 



