Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab1JCFU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:20:57 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:51808 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976Ab1JCFUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:20:52 -0400
Message-ID: <4E89462D.7010208@ti.com>
Date: Mon, 03 Oct 2011 10:50:45 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 24/30] ARM: omap2+: ensure that one of omap2/3/4 is selected
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-25-git-send-email-arnd@arndb.de>
In-Reply-To: <1317566760-25681-25-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 08:15 PM, Arnd Bergmann wrote:
> Random configurations can fail if none of the omap families
> in mach-omap2 is selected. This patch automatically selects
> omap2 if the user has not made any other choice.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

OMAP4 would have been a better default but am fine with
OMAP2 too.

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
