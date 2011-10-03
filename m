Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab1JCFIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:08:42 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:39817 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755045Ab1JCFId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:08:33 -0400
Message-ID: <4E89434B.2040503@ti.com>
Date: Mon, 03 Oct 2011 10:38:27 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/30] ARM: omap: fix visibility of omap2_mbox_iva_priv
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-8-git-send-email-arnd@arndb.de>
In-Reply-To: <1317566760-25681-8-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 08:15 PM, Arnd Bergmann wrote:
> map2_mbox_iva_priv is used on multiple omap2 socs but is hidden
> in an outdated #ifdef that is specific to a single soc.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
