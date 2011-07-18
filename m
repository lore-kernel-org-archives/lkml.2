Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab1GRW36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 18:29:58 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61129 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1GRW35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 18:29:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110716193000.dcf43d072610fbaa873e28d1@canb.auug.org.au>
References: <20110716193000.dcf43d072610fbaa873e28d1@canb.auug.org.au>
Date: Tue, 19 Jul 2011 00:29:55 +0200
Message-ID: <CAJ0pr19qxjtYACzzNZBpxnSGnTOp53Oy0Vxih0Xy-EzQEK4GKw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
From: Per Forlin <per.forlin@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Ball <cjb@laptop.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16 July 2011 11:30, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Chris,
>
> After merging the mmc tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> drivers/mmc/core/core.c:2141:1: error: redefinition of '__inittest'
> drivers/mmc/core/core.c:125:1: note: previous definition of '__inittest' was here
> drivers/mmc/core/core.c:2141:1: error: redefinition of 'init_module'
> drivers/mmc/core/core.c:125:1: note: previous definition of 'init_module' was here
>
> Seems to be caused by commit 65cae3d20446 ("mmc: core: add random fault
> injection").
This patch makes core.c contain two init_module, obviously an error if
building allmodconfig. I need to rework this patch and resend it.
I checked mmc-next just now and it has been removed already (thanks Chris).

Regards,
Per
