Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab2FTJKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:10:17 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:35427 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2FTJKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:10:15 -0400
MIME-Version: 1.0
In-Reply-To: <1340181845-14582-1-git-send-email-ldewangan@nvidia.com>
References: <1340181845-14582-1-git-send-email-ldewangan@nvidia.com>
Date: Wed, 20 Jun 2012 11:10:14 +0200
Message-ID: <CACRpkdZ+Q8M4gKCcEEFizADbTLuaD9yFyrThkpUSgdFCwsX4tA@mail.gmail.com>
Subject: Re: [PATCH RESEND] gpio: fix bits conflict for gpio flags
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 10:44 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> The bit 2 and 3 in GPIO flag are allocated for the
> flag OPEN_DRAIN/OPEN_SOURCE. These bits are reused
> for the flag EXPORT/EXPORT_CHANGEABLE and so creating
> conflict.
> Fix this conflict by assigning bit 4 and 5 for the
> flag EXPORT/EXPORT_CHANGEABLE.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>
This should be Cc: to stable as well I think.

Yours,
Linus Walleij
