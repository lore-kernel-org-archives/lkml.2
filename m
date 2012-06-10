Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab2FJMFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 08:05:10 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60653 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2FJMFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 08:05:08 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.19.137]
In-Reply-To: <1338989907-25360-2-git-send-email-sjur.brandeland@stericsson.com>
References: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com> <1338989907-25360-2-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 10 Jun 2012 15:04:47 +0300
Message-ID: <CAK=WgbbCYmGDATEG-cQFphcvhjZszpW7=mD3qd6q4VN-gZusDg@mail.gmail.com>
Subject: Re: [PATCH 1/7] remoteproc: fix print format warnings
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 4:38 PM, <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Fix compile warnings from GCC 4.6.1 when printing values of type size_t.
>
> drivers/remoteproc/remoteproc_core.c:251:6:
> warning: format ‘%x’ expects argument of type ‘unsigned int’,
> but argument 4 has type ‘size_t’ [-Wformat]
> drivers/remoteproc/remoteproc_core.c:938:9:
> warning: format ‘%u’ expects argument of type ‘unsigned int’,
> but argument 4 has type ‘size_t’ [-Wformat]
> drivers/remoteproc/remoteproc_core.c:1023:2:
> warning: format ‘%d’ expects argument of type ‘int’,
> but argument 4 has type ‘size_t’ [-Wformat]
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Cc'ed stable, applied and pushed to remoteproc's fixes branch.

Thanks,
Ohad.
