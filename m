Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1F0XB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:01:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49699 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab1F0XAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:00:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sGA02sbXrBBdSU9dfKzjpMhVeAIh9W062vsVi/ZbRMCDuATYfiBcxHUbyH7JOHfFmy
         LTWxoI6XXrmK8y2thEbrw80ZCndZASyu98iZSbRyJ5vvhuP7DW0kp3UjcuNsoaLbWaR4
         AtWtJEQocFfb3BTxJuozail7uiuf5Jfb0YsTs=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1106271619350.24034@linux>
References: <alpine.LNX.2.00.1106271619350.24034@linux>
Date: Mon, 27 Jun 2011 19:00:24 -0400
Message-ID: <BANLkTimrUYk-8GSsf35mUmLVBAaO84R6dA@mail.gmail.com>
Subject: Re: [PATCH] kbuild: silence generated makefile message
From: Arnaud Lacombe <lacombar@gmail.com>
To: Peter Foley <pefoley2@verizon.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 27, 2011 at 5:42 PM, Peter Foley <pefoley2@verizon.net> wrote:
>
> This patch silences the make -C /usr/src/git O=/usr/src/git/build/.
> message shown when using the generated makefile in KBUILD_OUTDIR.
>
I would expect verbose build to show that message. not hides it
unconditionally, no ?

 - Arnaud

> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>  scripts/mkmakefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/mkmakefile b/scripts/mkmakefile
> index 5325423..f4642f2 100644
> --- a/scripts/mkmakefile
> +++ b/scripts/mkmakefile
> @@ -40,7 +40,7 @@ MAKEFLAGS += --no-print-directory
>  all    := \$(filter-out all Makefile,\$(MAKECMDGOALS))
>
>  all:
> -       \$(MAKE) \$(MAKEARGS) \$(all)
> +       @\$(MAKE) \$(MAKEARGS) \$(all)
>
>  Makefile:;
>
> --
> 1.7.5.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
