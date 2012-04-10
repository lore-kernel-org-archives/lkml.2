Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab2DJIS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:18:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42101 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab2DJISY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:18:24 -0400
MIME-Version: 1.0
In-Reply-To: <1333553270-9040-2-git-send-email-swarren@wwwdotorg.org>
References: <1333553270-9040-1-git-send-email-swarren@wwwdotorg.org>
	<1333553270-9040-2-git-send-email-swarren@wwwdotorg.org>
Date: Tue, 10 Apr 2012 10:18:23 +0200
Message-ID: <CACRpkdZUad1qsP_=NqOfU9wMBJcJwCSprqnb-VQruDjqTW9pjA@mail.gmail.com>
Subject: Re: [PATCH V4 REPOST 2/5] dt: pinctrl: Document device tree binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 5:27 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> The core pin controller bindings define:
> * The fact that pin controllers expose pin configurations as nodes in
>  device tree.
> * That the bindings for those pin configuration nodes is defined by the
>  individual pin controller drivers.
> * A standardized set of properties for client devices to define numbered
>  or named pin configuration states, each referring to some number of the
>  afore-mentioned pin configuration nodes.
> * That the bindings for the client devices determines the set of numbered
>  or named states that must exist.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> Acked-by: Tony Lindgren <tony@atomide.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Simon Glass <sjg@chromium.org>
> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Would be nice to have an ACK from Grant or Rob but the massive
set of ACKs at the end still makes me tentatively apply this patch for
the pinctrl tree.

Yours,
Linus Walleij
