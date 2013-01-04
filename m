Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab3ADVYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:24:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40839 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab3ADVY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:24:27 -0500
Date: Fri, 04 Jan 2013 13:24:26 -0800 (PST)
Message-Id: <20130104.132426.2174792167438869648.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-01-04
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130104205343.GB21871@tuxdriver.com>
References: <20130104205343.GB21871@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 4 Jan 2013 15:53:43 -0500

> Arend "fixes" a copyright notice in brcmsmac -- seems harmless.
> 
> Christian Lamparter adds a device ID to p54usb, and changes the
> interface combinations reported by carl9170 in order to get it
> working again.
> 
> Geert Uytterhoeven gives us a pair of fixes for Kconfig warnings
> about bcma and ssb.
> 
> Hante Meuleman fixes some IE parsing to get AP mode working with
> WPA2 security.
> 
> Jesper Juhl fixes a urb leak in rtlwifi.
> 
> Jussi Kivilinna fixes some mis-usage of usb_alloc_coherent in rtlwifi,
> avoiding a BUG on ARM.
> 
> Larry Finger provides a handful of rtlwifi fixes to avoid some log
> SPAM due to not checking the return of pci_map_single.
> 
> Niels Ole Salscheider changes a usleep_range in brcmsmac to use udelay
> instead, avoiding a "BUG: scheduling while atomic".
> 
> Rafa©© Mi©©ecki fixes an ID for a serial flash in the bcma code.
> 
> Sujith Manoharan provides a pair of ath9k fixes, one for a compilation
> break and one to correct some gain-related initvals.
> 
> Tomasz Guszkowski adds a device ID to p54usb.
> 
> Vladimir Kondratiev fixes a Kconfig problem which cause ath9k_htc
> not to build properly.
> 
> Please let me know if there are problems!

Pulled, thanks John.
