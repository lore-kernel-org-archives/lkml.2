Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1FZXgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 19:36:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59756 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab1FZXf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 19:35:58 -0400
MIME-Version: 1.0
In-Reply-To: <1309122180-12838-3-git-send-email-dbaryshkov@gmail.com>
References: <1309122180-12838-1-git-send-email-dbaryshkov@gmail.com> <1309122180-12838-3-git-send-email-dbaryshkov@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 26 Jun 2011 17:35:35 -0600
X-Google-Sender-Auth: 6_8N06ZrN8FsX6LuqQdh-h7tmeg
Message-ID: <BANLkTi=G30BB66a6cbTWbmfd0Zokm2Kz3A@mail.gmail.com>
Subject: Re: [PATCH 2/2] mtd/ofpart: add ofoldpart alias
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-mtd@lists.infradead.org, dedekind1@gmail.com,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 3:03 PM, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:
> ofpart.ko also provides ofoldpart MTD parser. Add respective
> MODULE_ALIAS("ofoldpart"); declaration.
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Is MODULE_ALIAS actually necessary for what is essentially a library
module?  I though MODULE_ALIAS was only needed to trigger loading a
module for specific hardware.  In this case, the module should be
autoloaded when another module needs it.  I may be misinformed though,
my module-foo is a little rusty.

g.

> ---
>  drivers/mtd/ofpart.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mtd/ofpart.c b/drivers/mtd/ofpart.c
> index aa33b8a..c4b8d17 100644
> --- a/drivers/mtd/ofpart.c
> +++ b/drivers/mtd/ofpart.c
> @@ -176,3 +176,4 @@ module_init(ofpart_parser_init);
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("Parser for MTD partitioning information in device tree");
>  MODULE_AUTHOR("Vitaly Wool, David Gibson");
> +MODULE_ALIAS("ofoldpart");
> --
> 1.7.5.4
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
