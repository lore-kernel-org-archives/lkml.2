Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1GFMjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 08:39:01 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:45355 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab1GFMjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 08:39:00 -0400
Message-ID: <4E1456D9.8090003@mvista.com>
Date: Wed, 06 Jul 2011 16:36:41 +0400
From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
Reply-To: vkuzmichev@mvista.com
Organization: MontaVista Software, LLC
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Wim Van Sebroeck <wim@iguana.be>,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@fluxnic.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 6/6] mpcore_wdt: Move declarations in a separate header
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <1309892440-3260-7-git-send-email-vkuzmichev@mvista.com> <201107061358.48496.arnd@arndb.de>
In-Reply-To: <201107061358.48496.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 07/06/2011 03:58 PM, Arnd Bergmann wrote:
> On Tuesday 05 July 2011, Vitaly Kuzmichev wrote:
>> Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
>> ---
>>  drivers/watchdog/mpcore_wdt.c |   26 +-------------------------
>>  drivers/watchdog/mpcore_wdt.h |   40 ++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 41 insertions(+), 25 deletions(-)
>>  create mode 100644 drivers/watchdog/mpcore_wdt.h
> 
> I don't see the point in this. IMHO it's better to leave the definitions
> in the same file that uses them, because they are not shared across
> multiple files.
> 
> If you intend to share them in the future, you should explain that
> in the changelog.

The patch is aimed to resolve checkpatch warning on "extern" function
prototype:

WARNING: externs should be avoided in .c files
#44: FILE: drivers/watchdog/mpcore_wdt.c:37:
+unsigned long twd_timer_get_rate(void);

If it's ok to leave this warning I would also like to throw out this patch.

Thanks,
Vitaly.
