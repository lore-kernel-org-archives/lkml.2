Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab2ETVPK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 17:15:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54200 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab2ETVPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 17:15:08 -0400
MIME-Version: 1.0
In-Reply-To: <1337262323-27692-10-git-send-email-lee.jones@linaro.org>
References: <1337262323-27692-1-git-send-email-lee.jones@linaro.org>
	<1337262323-27692-10-git-send-email-lee.jones@linaro.org>
Date: Sun, 20 May 2012 23:15:07 +0200
Message-ID: <CACRpkdbrL3WY2X-sbKk5cZ=mLCuYA=SBQ294ceaZ2PdA2Q4-Ag@mail.gmail.com>
Subject: Re: [PATCH 09/18] regulator: ab8500: Split up probe() into manageable pieces
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 3:45 PM, Lee Jones <lee.jones@linaro.org> wrote:

> ab8500's probe() function is becoming quite large, so in the lead
> up to Device Tree enablement which will fork the thread of execution
> this patch splits it into 3 main areas; basic error checking will
> remain in probe(), but regulator register initialisation and regulator
> registration have been moved to their own functions which will
> be called in sequence by probe() and the DT equivalent.
>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks to Mark for review and merge,

Linus Walleij
