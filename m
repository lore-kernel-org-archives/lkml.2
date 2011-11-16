Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab1KPFbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 00:31:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63513 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1KPFbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 00:31:03 -0500
MIME-Version: 1.0
In-Reply-To: <631c53d126feff0a99b61d9c9a00b308d2b638ee.1321398815.git.joe@perches.com>
References: <cover.1321398814.git.joe@perches.com>
	<631c53d126feff0a99b61d9c9a00b308d2b638ee.1321398815.git.joe@perches.com>
Date: Wed, 16 Nov 2011 14:31:00 +0900
Message-ID: <CAKYAXd8od8mcahm3+tqzbgumf7Th47h8yGhoqfmmyNKujCK2ag@mail.gmail.com>
Subject: Re: [PATCH 4/4] mmc: Add mmc_host_<level> logging
From: NamJae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Nicolas Pitre <nico@fluxnic.net>, Chris Ball <cjb@laptop.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, Bruce Chang <brucechang@via.com.tw>,
        Harald Welte <HaraldWelte@viatech.com>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/16 Joe Perches <joe@perches.com>:
> Centralize the pr_<level> uses of mmc_hostname into specific
> mmc_host_<level> calls to allow a flexible presentation style
> and shorten the code a bit.
>
> Add mmc_host_<level> macros.
> Convert the logging calls from:
>        pr_<level>("%s: ...", mmc_hostname(foo)
> to:
>        mmc_host_<level>(foo, ...)
>
> Add a couple of missing newlines.
> Convert bare printks to pr_cont where appropriate.
> Spelling/typo fix of initialiazed to initialized.
>
> Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: NamJae Jeon <linkinjeon@gmail.com>

> ---
