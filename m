Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1GFMMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 08:12:18 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:44434 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1GFMMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 08:12:17 -0400
Message-ID: <4E1450D9.3040601@mvista.com>
Date: Wed, 06 Jul 2011 16:11:05 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Vitaly Kuzmichev <vkuzmichev@mvista.com>
CC: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Wim Van Sebroeck <wim@iguana.be>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        arm@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 6/6] mpcore_wdt: Move declarations in a separate header
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <1309892440-3260-7-git-send-email-vkuzmichev@mvista.com>
In-Reply-To: <1309892440-3260-7-git-send-email-vkuzmichev@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05-07-2011 23:00, Vitaly Kuzmichev wrote:

> Signed-off-by: Vitaly Kuzmichev<vkuzmichev@mvista.com>
> ---
>   drivers/watchdog/mpcore_wdt.c |   26 +-------------------------
>   drivers/watchdog/mpcore_wdt.h |   40 ++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 41 insertions(+), 25 deletions(-)
>   create mode 100644 drivers/watchdog/mpcore_wdt.h

    Are the declarations only used by mpcore_wdt.c? If so, why we need a header?

WBR, Sergei
