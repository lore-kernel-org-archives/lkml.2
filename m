Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab2LGIJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 03:09:50 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57852 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2LGIJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 03:09:48 -0500
MIME-Version: 1.0
In-Reply-To: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com>
References: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com>
Date: Fri, 7 Dec 2012 09:09:47 +0100
Message-ID: <CACRpkdYZcEpN-BJy=3DPAQL+QgR+EyNeyABtAPE96+2hYxOQwQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] gpio: twl4030: Correct status reporting for outputs
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 6, 2012 at 11:52 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:

> As Grant commneted on the first version:
> https://lkml.org/lkml/2012/12/5/53
>
> Introduce bitfields to cache the directionand output status of the pins so we
> can report them correctly.
> To do this I did some cleanup within the driver to get rid of the global
> variables and moved them under a private structure, changed the locking as well
> to protect the bitfield operation.
> As a last patch I added a note that the PWMA/B handling should not be in this
> driver at all.

This looks good to me:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Since Grant was requesting the changes I'll let him decide to merge.

Yours,
Linus Walleij
