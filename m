Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab1CCKZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:25:53 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:20324 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756218Ab1CCKZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:25:51 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIf7bk1R8KK1/2dsb2JhbACmdHW+YA2FVASSDQ
Date: Thu, 3 Mar 2011 11:25:49 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: Re: [PATCH 1/1] WATCHDOG: sbc_fitpc2_wdt, fix crash on systems
	without DMI_BOARD_NAME
Message-ID: <20110303102549.GX3790@infomag.iguana.be>
References: <1298884589-6880-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298884589-6880-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> Some systems don't provide DMI_BOARD_NAME in their DMI tables. Avoid
> crash in such situations in fitpc2_wdt_init.
> 
> The fix is to check if the dmi_get_system_info return value is NULL.

Added to linux-2.6-watchdog-next. Will sent it over to Linus for inclusion in the mainline kernel in a couple of days.

Kind regards,
Wim.

