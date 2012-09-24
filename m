Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab2IXRJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:09:42 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58357 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab2IXRJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:09:38 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <1348506174-28641-1-git-send-email-swarren@wwwdotorg.org>
References: <1348506174-28641-1-git-send-email-swarren@wwwdotorg.org>
Date: Mon, 24 Sep 2012 10:09:36 -0700
Message-ID: <CAOesGMjv6nU3vH0KX56ib2ptLsDOR9KrDvGngHNLAmdBLyML+w@mail.gmail.com>
Subject: Re: [PATCH] irqchip: fill in empty Kconfig
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: arm@kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@xenotime.net>, Simon Arlott <simon@fire.lp0.eu>,
        Chris Boot <bootc@bootc.net>, Dom Cobley <popcornmix@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 24, 2012 at 10:02 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> Commit 89214f0 "ARM: bcm2835: add interrupt controller driver" added an
> empty drivers/irqchip/Kconfig. Empty files apparently don't work well
> with git (sometimes, with some versions?) so add some dummy content to
> resolve this issue.

Applied to arm-soc. Thanks.


-Olof
