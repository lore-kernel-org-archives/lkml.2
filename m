Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2FJMGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 08:06:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44347 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab2FJMFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 08:05:47 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.19.137]
In-Reply-To: <1338989907-25360-3-git-send-email-sjur.brandeland@stericsson.com>
References: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com> <1338989907-25360-3-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 10 Jun 2012 15:05:26 +0300
Message-ID: <CAK=WgbavwO5_u7RPCcCRE0oJdHYZM2Z3sXm76yHz9+Upz-c_4w@mail.gmail.com>
Subject: Re: [PATCH 2/7] remoteproc: Fix missing fault indication in error-path
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 4:38 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> If rproc_find_rsc_table() fails, rproc_fw_boot() must set
> return-value before jumping to clean_up label. Otherwise no
> error value is returned.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Cc'ed stable, applied and pushed to remoteproc's fixes branch.

Thanks,
Ohad.
