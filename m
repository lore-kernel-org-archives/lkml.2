Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab2KHF2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 00:28:05 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53041 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2KHF2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 00:28:03 -0500
Message-ID: <509B42E1.20601@nvidia.com>
Date: Wed, 07 Nov 2012 22:28:01 -0700
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] gpio: tegra: Staticize non-exported symbols
References: <1352342724.19098.2.camel@phoenix>
In-Reply-To: <1352342724.19098.2.camel@phoenix>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 07:45 PM, Axel Lin wrote:
> Both tegra_gpio_request() and tegra_gpio_free() are not referenced outside of
> this file, make them static.

Both patches,
Acked-by: Stephen Warren <swarren@nvidia.com>

