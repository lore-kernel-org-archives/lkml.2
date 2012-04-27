Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258Ab2D0OvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:51:09 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:43359 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759691Ab2D0OvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:51:07 -0400
Date: Fri, 27 Apr 2012 16:50:56 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        sshtylyov@mvista.com
Subject: Re: [PATCH v4] wdt: Device tree support for pnx4008-wdt
Message-ID: <20120427145056.GA17375@spo001.leaseweb.com>
References: <1334951729-1388-1-git-send-email-stigge@antcom.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334951729-1388-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

> This patch adds device tree support to pnx4008-wdt.c
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> 
> ---
> 
> Applies to v3.4-rc3
> 
> Changes since v3:
> * Fixed typo in patch description
> 
> Thanks to Sergei Shtylyov for reviewing!
> 
>  Documentation/devicetree/bindings/watchdog/pnx4008-wdt.txt |   13 +++++++++++++
>  drivers/watchdog/pnx4008_wdt.c                             |   10 ++++++++++
>  2 files changed, 23 insertions(+)

Will be added into the linux-watchdog git trees.

Kind regards,
Wim.

