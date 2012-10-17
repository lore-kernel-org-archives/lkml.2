Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2JQPsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:48:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60383 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab2JQPsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:48:19 -0400
Message-ID: <507ED340.8010703@wwwdotorg.org>
Date: Wed, 17 Oct 2012 09:48:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: linus.walleij@linaro.org
CC: Pritesh Raithatha <praithatha@nvidia.com>, linux-kernel@vger.kernel.org,
        swarren@nvidia.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: tegra: correct bank for pingroup and drv pingroup
References: <1350454897-18110-1-git-send-email-praithatha@nvidia.com>
In-Reply-To: <1350454897-18110-1-git-send-email-praithatha@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 12:21 AM, Pritesh Raithatha wrote:
> Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>

(dropping stable from CC)

Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>

Linus, if you could add Cc: stable when you commit it, that'd be useful
too. Thanks.

I have no idea how I screwed this up so badly, or how it worked when
programming completely bogus registers!

Adding a patch description would be useful especially for stable. A
useful patch description might be:

The bank numbers in the pinctrl driver must match the bank numbers in
the device tree. Swap the bank numbers in the driver to ensure this.
While we're at it, rename the #defines used for the bank base addresses
so it's more obvious which is which, and add comments indicating which
correspond to which device tree bank.
