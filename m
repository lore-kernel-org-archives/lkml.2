Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab1HPNGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:06:50 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51495 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1HPNGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:06:48 -0400
MIME-Version: 1.0
In-Reply-To: <1313499399.1603.92.camel@vkoul-udesk3>
References: <1313147667-3385-1-git-send-email-jaswinder.singh@linaro.org>
	<1313499399.1603.92.camel@vkoul-udesk3>
Date: Tue, 16 Aug 2011 15:06:47 +0200
Message-ID: <CACRpkdaY_wuz+zS-iKCPT-M7EpvtxCNX+OJ6NROSaQtZ6XoNMg@mail.gmail.com>
Subject: Re: [PATCH] DMAEngine: Define generic transfer request api
From: Linus Walleij <linus.walleij@linaro.org>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, sundaram@ti.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
        nsekhar@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 2:56 PM, Koul, Vinod <vinod.koul@intel.com> wrote:

> Currently we have two approaches to solve this problem first being the
> DMA_STRIDE_CONFIG proposed by Linus W, I feel this one is better
> approach as this can give client ability to configure each transfer
> rather than set for the channel. Linus W, do you agree?

I think Sundaram is in the position of doing some heavy work on
using one or the other of the API:s, and I think he is better
suited than anyone else of us to select what scheme to use,
in the end he's going to write the first code using the API.

Yours,
Linus Walleij
