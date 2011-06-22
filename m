Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab1FVOiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:38:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41521 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab1FVOiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:38:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=i6YGOjP2NUxv4CqNffTQ2VsXD2ATSTc2xtBkwcLyG1gIhPHNd9SUyGJDf0Ck0m1Pnc
         BnDH5VZCI3Tk/zq1NA5NUAoFqKoFsWdUWQa65FUe6I9Ge9JeeypwM/NFabXjPA1W2tUC
         XmKr8xaPlqRIADVe+x85eR2KgmjorOCQ4AzRk=
MIME-Version: 1.0
In-Reply-To: <1308744176-24491-1-git-send-email-galak@kernel.crashing.org>
References: <1308744176-24491-1-git-send-email-galak@kernel.crashing.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 22 Jun 2011 10:37:40 -0400
Message-ID: <BANLkTin+_G7HZgBTy-=EWZBR0hBAPyKv3w@mail.gmail.com>
Subject: Re: [PATCH 1/3] driver core: Add ability for arch code to setup pdev_archdata
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 08:02, Kumar Gala wrote:
> --- /dev/null
> +++ b/include/asm-generic/platform_device.h
> @@ -0,0 +1,11 @@

missing header blob with explanation/copyright/license

> +/*
> + * an architecture can override to define arch_setup_pdev_archdata
> + */
> +#ifndef arch_setup_pdev_archdata
> +static inline void arch_setup_pdev_archdata(struct platform_device *pdev) { }
> +#endif

missing explanation of what the func actually does, and this header
lacks a forward struct decl for platform_device
-mike
