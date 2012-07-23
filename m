Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab2GWVEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 17:04:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57505 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab2GWVEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 17:04:12 -0400
Message-ID: <500DBC49.1080605@wwwdotorg.org>
Date: Mon, 23 Jul 2012 15:04:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, swarren@nvidia.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 5/6] ARM: tegra: defconfig: enable tps6586x gpio
References: <1342592450-12488-1-git-send-email-ldewangan@nvidia.com> <1342592450-12488-6-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1342592450-12488-6-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 12:20 AM, Laxman Dewangan wrote:
> Enable GPIO_TPS6586X as the gpio functionality of
> this device moved as platform driver.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
