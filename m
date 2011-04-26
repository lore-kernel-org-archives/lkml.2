Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab1DZGsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:48:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59294 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886Ab1DZGse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:48:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nCZEL45+w8a2rRe0323YRIE3QfihiQYNvg0Zc0Sn6zDC8tcEIkU+lf9+n47GD7FjpI
         2OCPotdHMKsRwBlI4TMbs1h9rbYepkf77od9gUvfI2jARAC6jHFonAXVenGc2FUSmR9b
         WFRmaYEPfkpAbe6P8hXkYIC7GEWjP3wW7Y8Ew=
MIME-Version: 1.0
In-Reply-To: <4DB4AEF7.3090607@verizon.net>
References: <4DB4AEF7.3090607@verizon.net>
Date: Tue, 26 Apr 2011 02:48:34 -0400
Message-ID: <BANLkTi=K3OEumicFMCT_Dh=xhpzfpa3JBw@mail.gmail.com>
Subject: Re: [PATCH] kbuild: mark unicore32 header export as broken
From: Arnaud Lacombe <lacombar@gmail.com>
To: pefoley2@verizon.net
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Apr 24, 2011 at 7:15 PM, Peter Foley <pefoley2@verizon.net> wrote:
> This patch marks userspace header export for unicore32 as broken so that
> it is skipped when running make headers_install_all.
>
Why ?

I would expect you to send this to arch/unicore32 maintainer too, he
is not in the CC: list.

 - Arnaud

> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>  scripts/headers.sh |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/scripts/headers.sh b/scripts/headers.sh
> index 978b42b..3ae218e 100755
> --- a/scripts/headers.sh
> +++ b/scripts/headers.sh
> @@ -21,6 +21,8 @@ for arch in ${archs}; do
>                ;;
>        cris)      # headers export are known broken
>                ;;
> +       unicore32) # broken
> +               ;;
>        *)
>                if [ -d ${srctree}/arch/${arch} ]; then
>                        do_command $1 ${arch}
> --
> 1.7.5.rc1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
