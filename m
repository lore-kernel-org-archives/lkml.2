Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab1F1Hlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:41:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42526 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab1F1Hky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:message-id
         :mime-version;
        b=rfTBoLhxslXjIvSkblWgTMb+rl6szciZYqxcZD8ziUh+XE+bdz2+YwI+wPGwGpNDcM
         YwaJjTiQqRYnVT6gdfuC/ZJnPORJslr/RQMI7nnwk3a1G3BiwLQqqoebYbJDwsBOcPKg
         BbHdOE198LTf0NKYQeJQRe8A0RgcmrcWVT8oQ=
Subject: Re: [PATCH 2/2] mtd/ofpart: add ofoldpart alias
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-mtd@lists.infradead.org, Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 28 Jun 2011 10:41:41 +0300
In-Reply-To: <1309178086-10604-1-git-send-email-dbaryshkov@gmail.com>
References: <1309154611.23597.18.camel@sauron>
	 <1309178086-10604-1-git-send-email-dbaryshkov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1309246907.23597.34.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 16:34 +0400, Dmitry Eremin-Solenikov wrote:
> ofpart.ko also provides ofoldpart MTD parser. Add respective
> MODULE_ALIAS("ofoldpart"); declaration.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> ---
>  drivers/mtd/ofpart.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mtd/ofpart.c b/drivers/mtd/ofpart.c
> index aa33b8a..77f0640 100644
> --- a/drivers/mtd/ofpart.c
> +++ b/drivers/mtd/ofpart.c
> @@ -176,3 +176,6 @@ module_init(ofpart_parser_init);
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("Parser for MTD partitioning information in device tree");
>  MODULE_AUTHOR("Vitaly Wool, David Gibson");
> +/* Required so that this module will be picked up ofoldpart
> + * MTD partition information parser */
> +MODULE_ALIAS("ofoldpart");

Well, the codyng style documents how multi-line comments should look
like... And this comment is less readable than your previous
explanation... But I've fixed this myself and pushed to my tree, thanks!

-- 
Best Regards,
Artem Bityutskiy

