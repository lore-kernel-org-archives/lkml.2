Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1KRVgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:36:07 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38661 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab1KRVgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:36:01 -0500
Message-ID: <4EC6CFBC.3090502@deeprootsystems.com>
Date: Fri, 18 Nov 2011 13:35:56 -0800
From: Kevin Hilman <khilman@deeprootsystems.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: Tero Kristo <t-kristo@ti.com>
CC: linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCHv9 05/18] mfd: omap-prm: add driver skeleton
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com> <1316781986-30642-6-git-send-email-t-kristo@ti.com>
In-Reply-To: <1316781986-30642-6-git-send-email-t-kristo@ti.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 05:46 AM, Tero Kristo wrote:
> This driver will eventually support OMAP soc PRM module features, e.g. PRCM
> chain interrupts and voltage processor / controller. This patch only adds
> basic skeleton for the driver that can be probed for omap3 and omap4.
> 
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>

> +config OMAP_PRM
> +	bool "OMAP Power and Reset Management driver"
> +	depends on (ARCH_OMAP) && PM

Minor: this should probably be

	default ARCH_OMAP && PM

So it's enabled by default whenever a PM kernel is built for OMAP.

Kevin
