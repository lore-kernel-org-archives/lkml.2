Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab1JCFVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:21:53 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:50588 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753391Ab1JCFVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:21:46 -0400
Message-ID: <4E894664.5090609@ti.com>
Date: Mon, 03 Oct 2011 10:51:40 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/30] ARM: OMAP depends on MMU
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-26-git-send-email-arnd@arndb.de>
In-Reply-To: <1317566760-25681-26-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 08:15 PM, Arnd Bergmann wrote:
> There is no way to build OMAP kernels without an MMU
> at this point because of dependencies on MMU-only functions.
> 
> As long as nobody is interested in fixing this, let's just disable
> this platforms for nommu kernels.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
