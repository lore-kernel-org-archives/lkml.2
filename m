Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab2JQPE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:04:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61571 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab2JQPE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:04:56 -0400
Date: Wed, 17 Oct 2012 08:04:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Pritesh Raithatha <praithatha@nvidia.com>
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org, swarren@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: tegra: correct bank for pingroup and drv
 pingroup
Message-ID: <20121017150443.GA29480@kroah.com>
References: <1350454897-18110-1-git-send-email-praithatha@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350454897-18110-1-git-send-email-praithatha@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 11:51:37AM +0530, Pritesh Raithatha wrote:
> Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
> ---
>  drivers/pinctrl/pinctrl-tegra30.c |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
