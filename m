Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab0LIEPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 23:15:35 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:42745 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab0LIEPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 23:15:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jm2o7SPF9WHzCwjH1x+5JfhB6ec2RvF73eeCoJ2FvNd23+cPt41C/7JKcqI7EXAMj/
         UIvMp4EhOJthohPlnb1Va9C5GbQq2UaQxdzat9T9iX8zyykSRBbUKJ6UupO7qHO6OHWA
         KLLNBI0x0tXbxPkCC8sxQDx8cSyDpC3meYtfI=
MIME-Version: 1.0
In-Reply-To: <1291867641-31998-1-git-send-email-namhyung@gmail.com>
References: <1291867641-31998-1-git-send-email-namhyung@gmail.com>
From: Matt Turner <mattst88@gmail.com>
Date: Thu, 9 Dec 2010 04:15:11 +0000
Message-ID: <AANLkTika4_MwT_FknXGh-Q+Ve_ZL+opWBb5+vaCR-q9t@mail.gmail.com>
Subject: Re: [PATCH] alpha/osf_sys: remove unused MAX_SELECT_SECONDS
To: Namhyung Kim <namhyung@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 4:07 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> Remove the leftover from the commit 14e2acd86865 ("select:
> fix alpha OSF wrapper").
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  arch/alpha/kernel/osf_sys.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
> index 547e8b84b2f7..fe698b5045e9 100644
> --- a/arch/alpha/kernel/osf_sys.c
> +++ b/arch/alpha/kernel/osf_sys.c
> @@ -951,9 +951,6 @@ SYSCALL_DEFINE2(osf_utimes, const char __user *, filename,
>        return do_utimes(AT_FDCWD, filename, tvs ? tv : NULL, 0);
>  }
>
> -#define MAX_SELECT_SECONDS \
> -       ((unsigned long) (MAX_SCHEDULE_TIMEOUT / HZ)-1)
> -
>  SYSCALL_DEFINE5(osf_select, int, n, fd_set __user *, inp, fd_set __user *, outp,
>                fd_set __user *, exp, struct timeval32 __user *, tvp)
>  {
> --
> 1.7.3.3.400.g93cef

Thanks! I'll vacuum this up for the next merge window.

Matt
