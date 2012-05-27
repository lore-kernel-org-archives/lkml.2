Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2E0VdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 17:33:21 -0400
Received: from nm17.access.bullet.mail.mud.yahoo.com ([66.94.237.218]:39635
	"HELO nm17.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752681Ab2E0VdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 17:33:18 -0400
X-Yahoo-Newman-Id: 443181.59514.bm@smtp107.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7R0U8vYVM1l64A2f74gm22kmA7k000XiOtA2UaGamYXrBTw
 MDidJQXlbCV2CzUKAJuVbdRq74DHBwsFp8Y4FNgOTv6MbiRnF_74Zk_gWoSG
 OEsLJKrjE48LZcfZvKmWXxbJSk5CVopvU9x9h18JMjLTVyqV1XfGqeHZZkJH
 GjBgz_iyaVHn38TVKLc3dGn3vIRnByT32KVHGOx2dOP3ygCDzWUwbFHlMB_9
 0XCF3w7bBQ3Cl7h8uoU8XiMA8CD1yAs.k.5e_l2r1ARcJIxoIOOmGj63gZji
 PaCvjEP_BHxDuPXFLCqGno1Fs0mbGaUWKTYNcHGH7_B52HRqomBJPgCBo8Oa
 8Qm.Y1fZ3mIv8T2kfTBdNHeLqKG_vWYP2AwzNpNBL_FxkBc.uBjL4m9vgBdl
 y8t8.71So_Tj22ZWmLOLkEOplqYdIjCEY9S9xNJpWhDZJZ_PhKHiQRf4rNFs
 vYonl5ScK20R1NjDebkxdJVIVb6SUrArLYC3ZcU3oZl.M6LSSu9JHE2csfdZ
 L5XXiT8nSyMgRT5.psz2tD9CskZvLQYFsYk0b0g0IwmrdTi95QQ9Pi_GrxoY
 RJI6luDb_WzppsKr9GowN.IUQBkN7_BTtgT63Cay86j6ebE_yK05JyRQ5ebW
 Adj1nXA--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4FC29D9C.5070309@schaufler-ca.com>
Date: Sun, 27 May 2012 14:33:16 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] Smack: Maintainer Record
References: <4FBD903C.7080903@schaufler-ca.com>
In-Reply-To: <4FBD903C.7080903@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/2012 6:34 PM, Casey Schaufler wrote:
> From: Casey Schaufler <casey@schaufler-ca.com>
> Subject: [PATCH] Smack: Maintainer Record
>
> Add a maintainer record for the Smack LSM.
>
> Targeted for git://git.gitorious.org/smack-next/kernel.git
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Applied to git://gitorious.org/smack-next/kernel.git

>
> ---
>
>  MAINTAINERS |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d7ca204..ccc8a14 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6133,6 +6133,15 @@ S:	Maintained
>  F:	include/linux/sl?b*.h
>  F:	mm/sl?b.c
>  
> +SMACK SECURITY MODULE
> +M:	Casey Schaufler <casey@schaufler-ca.com>
> +L:	linux-security-module@vger.kernel.org
> +W:	http://schaufler-ca.com
> +T:	git git://git.gitorious.org/smack-next/kernel.git
> +S:	Maintained
> +F:	Documentation/security/Smack.txt
> +F:	security/smack/
> +
>  SMC91x ETHERNET DRIVER
>  M:	Nicolas Pitre <nico@fluxnic.net>
>  S:	Odd Fixes
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

