Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab2LSL1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 06:27:15 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:47862 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab2LSL1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 06:27:03 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3] of: Output devicetree alias names in uevent
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Rob Herring <rob.herring@calxeda.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Brown <davidb@codeaurora.org>, mbohan@codeaurora.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
In-Reply-To: <1354834541-26765-1-git-send-email-stepanm@codeaurora.org>
References: <20121206192500.0BF073E3A5E@localhost> <1354834541-26765-1-git-send-email-stepanm@codeaurora.org>
Date: Wed, 19 Dec 2012 11:26:55 +0000
Message-Id: <20121219112655.AC0503E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Dec 2012 14:55:41 -0800, Stepan Moskovchenko <stepanm@codeaurora.org> wrote:
> In some situations, userspace may want to resolve a
> device by function and logical number (ie, "serial0")
> rather than by the base address or full device path. Being
> able to resolve a device by alias frees userspace from the
> burden of otherwise having to maintain a mapping between
> device addresses and their logical assignments on each
> platform when multiple instances of the same hardware block
> are present in the system.
> 
> Although the uevent device attribute contains devicetree
> compatible information and the full device path, the uevent
> does not list the alises that may have been defined for the
> device.
> 
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>

I've picked this up into my devicetree/next branch. It will get pushed out to linux-next after the merge window closes.

Thanks,
g.

