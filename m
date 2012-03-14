Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab2CNHMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:12:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40928 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab2CNHMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:12:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1203132258460.5229@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1203132258160.5229@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1203132258460.5229@chino.kir.corp.google.com>
Date: Wed, 14 Mar 2012 08:12:32 +0100
Message-ID: <CAHR064hOBPToe6XzyKV6dfXM0sXgMcGWtM-+xyezsUQe1JzXtg@mail.gmail.com>
Subject: Re: [patch -next 2/2] drivers, samsung-laptop: fix usage of isalnum
From: Corentin Chary <corentin.chary@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 6:59 AM, David Rientjes <rientjes@google.com> wrote:
> linux/ctype.h is needed for isalnum() to avoid a build error:
>
> drivers/platform/x86/samsung-laptop.c: In function ‘samsung_sabi_diag’:
> drivers/platform/x86/samsung-laptop.c:1306: error: implicit declaration of function ‘isalnum’
>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  drivers/platform/x86/samsung-laptop.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
> --- a/drivers/platform/x86/samsung-laptop.c
> +++ b/drivers/platform/x86/samsung-laptop.c
> @@ -25,6 +25,7 @@
>  #include <linux/acpi.h>
>  #include <linux/seq_file.h>
>  #include <linux/debugfs.h>
> +#include <linux/ctype.h>
>
>  /*
>  * This driver is needed because a number of Samsung laptops do not hook

Acked-by: Corentin Chary <corentincj@iksaif.net>

-- 
Corentin Chary
http://xf.iksaif.net
