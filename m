Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab2KUIVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:21:07 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37373 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2KUIVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:21:04 -0500
MIME-Version: 1.0
In-Reply-To: <1353349867-28494-11-git-send-email-swarren@wwwdotorg.org>
References: <1353349867-28494-1-git-send-email-swarren@wwwdotorg.org>
	<1353349867-28494-11-git-send-email-swarren@wwwdotorg.org>
Date: Wed, 21 Nov 2012 09:21:03 +0100
Message-ID: <CACRpkdYBfh49qxfAi6Kt74rVbqSRCioF6O=87gXrhzK=3YR6TQ@mail.gmail.com>
Subject: Re: [PATCH V3 10/11] ARM: remove struct sys_timer suspend and resume fields
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 7:31 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> These fields duplicate e.g. struct clock_event_device's suspend and
> resume fields, so remove them now that nothing is using them. The aim
> is to remove all fields from struct sys_timer except .init, then replace
> the ARM machine descriptor's .timer field with a .init_time function
> instead, and delete struct sys_timer.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
