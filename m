Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030319Ab2KXJqB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 04:46:01 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64976 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030191Ab2KXJp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 04:45:59 -0500
MIME-Version: 1.0
In-Reply-To: <20121124083140.791341108@redhat.com>
References: <20121124082918.671430919@redhat.com>
	<20121124083140.791341108@redhat.com>
Date: Sat, 24 Nov 2012 11:45:59 +0200
X-Google-Sender-Auth: PBf6NrCxgESdCnXkOKoJEr2Tm1s
Message-ID: <CAOJsxLGqzBq9RP3A+9DU8ondpfV-rkKOXR46+SOo0TzQrzH=AQ@mail.gmail.com>
Subject: Re: [patch 8/8] breakpoint selftests: print failure status instead of
 cause make error
From: Pekka Enberg <penberg@kernel.org>
To: dyoung@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 10:29 AM,  <dyoung@redhat.com> wrote:
> In case breakpoint test exit non zero value it will cause make error.
> Better way is just print the test failure status.
>
> Signed-off-by: Dave Young <dyoung@redhat.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>

> ---
>  tools/testing/selftests/breakpoints/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-2.6.orig/tools/testing/selftests/breakpoints/Makefile 2012-11-23 22:37:04.749058409 +0800
> +++ linux-2.6/tools/testing/selftests/breakpoints/Makefile      2012-11-23 22:38:43.221858269 +0800
> @@ -17,7 +17,7 @@ else
>  endif
>
>  run_tests:
> -       ./breakpoint_test
> +       @./breakpoint_test || echo "breakpoints selftests: [FAIL]"
>
>  clean:
>         rm -fr breakpoint_test
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
