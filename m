Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab2FJOuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:50:23 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48652 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2FJOuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:50:22 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.19.137]
In-Reply-To: <1338989907-25360-4-git-send-email-sjur.brandeland@stericsson.com>
References: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com> <1338989907-25360-4-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 10 Jun 2012 17:50:01 +0300
Message-ID: <CAK=WgbaAyAJBW85C43EMf_gDTOOh=MDML_PvJXGVagN8n19SNg@mail.gmail.com>
Subject: Re: [PATCH 3/7] remoteproc: Pass struct fw to load_segments and find_rsc_table.
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
> Prepare for introduction of custom firmware loaders by changing
> the functions rproc_find_rcs_table() and rproc_load_segments()
> to use struct firmware as parameter.
>
> When the custom loader framework is introduced all calls into
> the firmware specific function must use struct firmware as
> parameter.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Looks good, just a small typo below:

> + * @fw: the  the ELF firmware image
