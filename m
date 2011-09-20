Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1ITXzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 19:55:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47277 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab1ITXzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 19:55:35 -0400
MIME-Version: 1.0
In-Reply-To: <1316548373-8782-5-git-send-email-zohar@linux.vnet.ibm.com>
References: <1316548373-8782-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1316548373-8782-5-git-send-email-zohar@linux.vnet.ibm.com>
Date: Wed, 21 Sep 2011 02:55:35 +0300
Message-ID: <CAHp75VcQd9CjCKHVWjb7pDzFWCHMTcpTrzG4hHfiLu27F+Tfmg@mail.gmail.com>
Subject: Re: [PATCH v1 4/4] target: check hex2bin result
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Arnaud Lacombe <lacombar@gmail.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 10:52 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> Now that hex2bin does error checking, on error add debugging error msg.
>
> Changelog v1:
> - hex2bin now returns an int
>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  drivers/target/target_core_fabric_lib.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
> index c4ea3a9..17658ca 100644
> --- a/drivers/target/target_core_fabric_lib.c
> +++ b/drivers/target/target_core_fabric_lib.c
> @@ -63,6 +63,7 @@ u32 sas_get_pr_transport_id(
>        unsigned char *buf)
>  {
>        unsigned char *ptr;
> +       bool ret;
I'm sorry for this, but I guess you meant int?
>
>        /*
>         * Set PROTOCOL IDENTIFIER to 6h for SAS

> @@ -158,6 +161,8 @@ u32 fc_get_pr_transport_id(
>        unsigned char *ptr;
>        int i;
>        u32 off = 8;
> +       bool ret;
Ditto.
> +
>        /*
>         * PROTOCOL IDENTIFIER is 0h for FCP-2
>         *
Otherwise have my Acked-by. I think Andrew also will be happy.


-- 
With Best Regards,
Andy Shevchenko
