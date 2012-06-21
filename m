Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258Ab2FUJ4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:56:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45272 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759240Ab2FUJ43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:56:29 -0400
MIME-Version: 1.0
In-Reply-To: <7510940.OaXg6CbgK9@flexo>
References: <1340269017-11701-1-git-send-email-richard.genoud@gmail.com> <7510940.OaXg6CbgK9@flexo>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 21 Jun 2012 11:56:13 +0200
Message-ID: <CACQ1gAhsbv4QE-DjcYF1+YaVForG8TtQ=fjSBmBtXkUQxLYWLw@mail.gmail.com>
Subject: Re: [PATCH] ARM: zImage: Allow DTB command line concatenation with ATAG_CMDLINE
To: Florian Fainelli <florian@openwrt.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/21 Florian Fainelli <florian@openwrt.org>:
> The only thing which is ARM-specific and not yet resolved is the following: if
> you have ARM_ATAG_DTB_COMPAT enabled, the kernel command-line contains only
> the bootloader supplied command-line and not bootloader + bootargs from DT. I
> have not yet had a chance to get this sorted.
That's the whole point of this patch : to have bootloader + bootargs
from DT when ARM_ATAG_DTB_COMPAT is enabled.

Richard.
