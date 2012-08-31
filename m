Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2HaWxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 18:53:14 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43818 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab2HaWxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 18:53:12 -0400
MIME-Version: 1.0
In-Reply-To: <503CFDFC.7060607@nvidia.com>
References: <1346137196-7138-1-git-send-email-swarren@wwwdotorg.org>
	<503CFDFC.7060607@nvidia.com>
Date: Sat, 1 Sep 2012 00:53:11 +0200
Message-ID: <CACRpkda3qN3VVOv6TxjXB9qTZc4CszvQpLb+mO1pdf1OuCn2wg@mail.gmail.com>
Subject: Re: [PATCH] gpio: tegra: remove useless includes of <mach/*.h>
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 7:21 PM, Stephen Warren <swarren@nvidia.com> wrote:
> On 08/27/2012 11:59 PM, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Nothing from these files is needed, so remove the includes. This helps
>> single zImage work by reducing use of the mach-tegra/include/mach/
>> directory.
>
> BTW, it'd be easiest for me to take this through the Tegra tree, since I
> may be able to delete <mach/suspend.h> after this.

OK go ahead,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
