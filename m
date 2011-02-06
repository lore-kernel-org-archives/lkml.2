Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab1BFSyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 13:54:13 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:59299 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab1BFSyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 13:54:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=LBQ58cHqo0ZP0ksmibxAlBN4RLsXSZpP/DCQ2hC96nXFqmkPLcCOKw0kxrakBOF88y
         8i7VdlLYKsVx7XytMhCYYpn7PtfVISLB9te0PKFueMXAODnvEIJ2zS2+KP/jTSZrEFxG
         X8OtzxC9FzyVCxx2LWsjpoXSx01byC4KB4ztU=
MIME-Version: 1.0
In-Reply-To: <cover.1297014479.git.pierre.tardy@intel.com>
References: <cover.1297014479.git.pierre.tardy@intel.com>
Date: Sun, 6 Feb 2011 19:54:11 +0100
X-Google-Sender-Auth: WH8-rHBYNZax8-18duo7IWHVqG0
Message-ID: <AANLkTinzhhZMC=dRhC5PbeK98UH8ZkOKMriEq0cU6g=q@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] sdhci runtime_pm implementation using mmc clock
 gating fw
From: Linus Walleij <linus.walleij@linaro.org>
To: Pierre Tardy <pierre.tardy@intel.com>
Cc: linux-pm@lists.linux-foundation.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/6 Pierre Tardy <pierre.tardy@intel.com>:

> Please find a simple sdhci runtime_pm implementation
> that uses clock gating fw as a tip to know when
> our chip is idle.

I like this approach, the gated clock hints to rpm that it's time
to idle the device. Great work.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

For all patches.

Thanks,
Linus Walleij
