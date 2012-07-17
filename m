Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab2GQARA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 20:17:00 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56784 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540Ab2GQAQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 20:16:58 -0400
X-Sasl-enc: NKKsw/9sgNYnhknJyJ0dyz4xybSwiXiWJI0p/RYuZhgc 1342484217
Date: Mon, 16 Jul 2012 17:16:56 -0700
From: Greg KH <greg@kroah.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        jg1.han@samsung.com, jy0922.shim@samsung.com,
        thomas.abraham@linaro.org, sshtylyov@mvista.com
Subject: Re: [PATCH 0/3 v3] USB: host: Add Device tree support for
 ohci-exynos & ehci-s5p
Message-ID: <20120717001656.GA20032@kroah.com>
References: <1342418138-6192-1-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342418138-6192-1-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 11:25:35AM +0530, Vivek Gautam wrote:
> Changes from v1:
> 1) Moved "struct of_device_id exynos_ehci_match[]"
> to the next of "struct dev_pm_ops s5p_ehci_pm_ops" in ehci-s5p.c.
> 2) Rebased on 'usb-next' branch.

I've applied the first 2 patches here, please rework the third one.

greg k-h
