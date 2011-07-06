Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1GFL7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 07:59:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51396 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1GFL7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 07:59:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: Re: [PATCH V2 6/6] mpcore_wdt: Move declarations in a separate header
Date: Wed, 6 Jul 2011 13:58:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Wim Van Sebroeck <wim@iguana.be>,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@fluxnic.net>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <1309892440-3260-7-git-send-email-vkuzmichev@mvista.com>
In-Reply-To: <1309892440-3260-7-git-send-email-vkuzmichev@mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107061358.48496.arnd@arndb.de>
X-Provags-ID: V02:K0:oVZA2bWIhZK40eA4GPWeeC6Uf4iuTA9MThID/vqgTem
 BkciHvkJsfxunK87s9zyvJ8KpZBhoOk3WEePP7ttopmFvIIGI/
 PuneQAjuWTE8w7OZCKunhWvJUZ2+Wp5w4KIxgv3QprsaXV0BKq
 C0qohXrRAzi4ll8wx4HOE1ML8m7pbz268PUzN9lAgsG4uvy5Hk
 SI3lBVpMlniNar6eaOMPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011, Vitaly Kuzmichev wrote:
> Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
> ---
>  drivers/watchdog/mpcore_wdt.c |   26 +-------------------------
>  drivers/watchdog/mpcore_wdt.h |   40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+), 25 deletions(-)
>  create mode 100644 drivers/watchdog/mpcore_wdt.h

I don't see the point in this. IMHO it's better to leave the definitions
in the same file that uses them, because they are not shared across
multiple files.

If you intend to share them in the future, you should explain that
in the changelog.

	Arnd
