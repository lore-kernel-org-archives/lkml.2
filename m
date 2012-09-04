Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab2IDWYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:24:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51212 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab2IDWX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:23:58 -0400
Message-ID: <50467F7B.1070409@wwwdotorg.org>
Date: Tue, 04 Sep 2012 16:23:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] gpio: tegra: remove useless includes of <mach/*.h>
References: <1346137196-7138-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1346137196-7138-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2012 12:59 AM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Nothing from these files is needed, so remove the includes. This helps
> single zImage work by reducing use of the mach-tegra/include/mach/
> directory.

Applied to Tegra's for-3.7/cleanup branch.

