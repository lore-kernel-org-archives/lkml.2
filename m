Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab1JRRTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:19:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:42353 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1JRRTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:19:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="64409676"
Subject: Re: 3.1.0-rc9+ : wlan stops working w/o any error messages
From: wwguy <wey-yi.w.guy@intel.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: werner <w.landgraf@ru.ru>, David Rientjes <rientjes@google.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <201110181847.02971.toralf.foerster@gmx.de>
References: <201110152119.58509.toralf.foerster@gmx.de>
	 <201110170952.43916.toralf.foerster@gmx.de>
	 <1318879847.17584.3.camel@wwguy-ubuntu>
	 <201110181847.02971.toralf.foerster@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 10:13:33 -0700
Message-ID: <1318958013.25023.16.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 09:47 -0700, Toralf Förster wrote:
> wwguy wrote at 21:30:47
> > In order to dump the the tx_queue, please do the following
> > 1. make sure you compile your kernel with CONFIG_IWLWIFI_DEBUGFS=y
> I'm unable to select that config option .
> 
> I double checked my config file - with the information from "make menuconfig" :
> 
>  Symbol: IWLWIFI_DEBUGFS [=n]
>  Type  : boolean
>  Prompt: iwlagn debugfs support
>    Defined at drivers/net/wireless/iwlwifi/Kconfig:72
>    Depends on: NETDEVICES [=y] && WLAN [=y] && IWLAGN [=m] && MAC80211_DEBUGFS [=n]
>    Location:
>      -> Device Drivers
>        -> Network device support (NETDEVICES [=y])
>          -> Wireless LAN (WLAN [=y])
>            -> Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate-N (iwlagn)  (IWLAGN [=m])
>              -> Debugging Options
> 
> 
> it looks all good (.config attached) - but the option itself isn't included in the kernel config file nor I can select it :-(
> 
hmm, something broken there, it should be in the .config file, what tree
you are using?

Thanks
Wey


