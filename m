Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab1G0TuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:50:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:22890 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab1G0TuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:50:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=reCLQ7R4lSrZEenSAFx8aTd2sKyIVS9XPsvBpd4fuMSYo56/p6rmeoO+R5djVYL3a
	2zxqbXxcBn8gzpqk2DwWA==
MIME-Version: 1.0
In-Reply-To: <20110727101128.8d63fbab.rdunlap@xenotime.net>
References: <20110727141151.d31e3da6a8d21a255473293c@canb.auug.org.au> <20110727101128.8d63fbab.rdunlap@xenotime.net>
From: Mike Waychison <mikew@google.com>
Date: Wed, 27 Jul 2011 12:49:59 -0700
Message-ID: <CAGTjWtBq39vBMWfk0aTZuw_kNQSUch8oUcg14VF5NpOwuuJiew@mail.gmail.com>
Subject: Re: [PATCH -next] firmware: fix google/gsmi.c build warning
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 10:11 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> Modify function parameter type to match expected type.  Fixes a
> build warning:
>
> drivers/firmware/google/gsmi.c:473: warning: initialization from incompatible pointer type
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Mike Waychison <mikew@google.com>
> ---
>  drivers/firmware/google/gsmi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20110727.orig/drivers/firmware/google/gsmi.c
> +++ linux-next-20110727/drivers/firmware/google/gsmi.c
> @@ -420,7 +420,7 @@ static efi_status_t gsmi_get_next_variab
>
>  static efi_status_t gsmi_set_variable(efi_char16_t *name,
>                                      efi_guid_t *vendor,
> -                                     unsigned long attr,
> +                                     u32 attr,
>                                      unsigned long data_size,
>                                      void *data)
>  {
>

Looks good.
