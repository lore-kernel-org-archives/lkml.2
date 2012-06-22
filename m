Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab2FVXJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:09:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38666 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2FVXJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:09:24 -0400
Date: Fri, 22 Jun 2012 16:09:18 -0700 (PDT)
Message-Id: <20120622.160918.90088993233016911.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-06-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120622201716.GB13918@tuxdriver.com>
References: <20120622201716.GB13918@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 22 Jun 2012 16:17:16 -0400

> Another quick round of fixes intended for 3.5...
> 
> Some of them are Bluetooth -- quoth Gustavo:
> 
> 	Five fixed to 3.5. There 2 new usb devices id commits, one
> 	driver fix and two other fixes for the core, one for L2CAP
> 	and other in MGMT interface.
> 
> The Bluetooth fixes look reasonable to me.
> 
> The mwifiex drivers gets a fix from Avinash Patil for a potential
> stuck tx queue in AP mode, and a fix from Bing Zhao for a crash from
> a bad return type.
> 
> Bob Copeland gives us a two-liner for ath5k to avoid a bottom half
> double lock.
> 
> Dan Carpenter gives us an airo fix to correct some incorrect pointer
> usage in a memcpy.
> 
> The wl1251 driver gets three fixes that Grazvydas Ignotas rescued from
> the Maemo repos.  One corrects a TSF calculation, another ensures
> that beacon losses are always reported up the stack, and the third
> corrects some memory leaks.
> 
> Johannes Berg gives us an iwlwifi fix to avoid a debugfs-releated
> crash.
> 
> Finally, the ath9k folks were busy!  Felix Fietkau fixes a tx rate
> duration calculation and an invalid pointer access, Mohammed Shafi
> Shajakhan avoids a potential infinite loop, and Rajkumar Manoharan
> ensures that the bssid is configured for ath9k_htc when association
> or ibss information changes.
> 
> Please let me know if there are problems!

Pulled, thanks John.
