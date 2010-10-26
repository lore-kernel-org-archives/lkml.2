Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0JZIEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:04:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44843 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0JZIEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KWrANZHcMzuh3LQdR9kLGD3dIzpcFZjuFUDJ2Lt4JQKIS4rH/FTDupUsTgPdPtrqD/
         TcWXF+RDfPanqXoo0cztZiV2sYv9Ya7wMTcXJaxCFXLhZBE2Y+jSyQebGRQ2UlvYgnw5
         EeLi9VmlZ1s4R1YHchVk7Yvn3tkWOMcg4Cmxc=
MIME-Version: 1.0
In-Reply-To: <1288042994-27761-1-git-send-email-sven.eckelmann@gmx.de>
References: <1288042994-27761-1-git-send-email-sven.eckelmann@gmx.de>
Date: Tue, 26 Oct 2010 11:04:31 +0300
Message-ID: <AANLkTimiMAeonjLpnuJNpeQhtdLmp+z1uqyjVfZbFmcr@mail.gmail.com>
Subject: Re: [PATCH] Staging: batman-adv: Remove useless braces
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Sven Eckelmann <sven.eckelmann@gmx.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's odd.

I've checked it before submission:

andy@fs-test:~/prj/linux-2.6(mine)$ git show
77099f0afe94928b5b0066a7efa5fa9f81696b54 | scripts/checkpatch.pl -
total: 0 errors, 0 warnings, 177 lines checked

Your patch has no obvious style problems and is ready for submission.

On Tue, Oct 26, 2010 at 12:43 AM, Sven Eckelmann <sven.eckelmann@gmx.de> wrote:
> 77099f0afe94928b5b0066a7efa5fa9f81696b54 added changes to vis.c which
> trigger a checkpatch.pl warning about braces which are not necessary
> anymore.
>
> WARNING: braces {} are not necessary for any arm of this statement
> +               if (entry->primary)
> [...]
> +               else {
> [...]
>
> Signed-off-by: Sven Eckelmann <sven.eckelmann@gmx.de>
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Marek Lindner <lindner_marek@yahoo.de>
> Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/staging/batman-adv/vis.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/batman-adv/vis.c b/drivers/staging/batman-adv/vis.c
> index 3d2c1bc..4473cc8 100644
> --- a/drivers/staging/batman-adv/vis.c
> +++ b/drivers/staging/batman-adv/vis.c
> @@ -135,9 +135,8 @@ static ssize_t vis_data_read_prim_sec(char *buff, struct hlist_head *if_list)
>        hlist_for_each_entry(entry, pos, if_list, list) {
>                if (entry->primary)
>                        len += sprintf(buff + len, "PRIMARY, ");
> -               else {
> +               else
>                        len += sprintf(buff + len,  "SEC %pM, ", entry->addr);
> -               }
>        }
>
>        return len;
> --
> 1.7.2.3
>
>



-- 
With Best Regards,
Andy Shevchenko
