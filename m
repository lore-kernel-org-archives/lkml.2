Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab0LEM3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 07:29:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65472 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab0LEM3D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 07:29:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X3ht8rC59OD8Ie+RKTbP7lZaeZhn722JMAGS9DbswTQJBMebxmXDWnR3BH+rAudM5k
         Il7fXPHiVuFhPtE3bKDf3Kwg/V02MqPwexuu2lASMgVgYYFwgd62bv2VtCxZnk3lc6Fg
         /FBrPkbSRWROsgsuytU1xqwOZ+eS65fokSW+E=
MIME-Version: 1.0
In-Reply-To: <1291432752-2466-1-git-send-email-bookjovi@gmail.com>
References: <1291432752-2466-1-git-send-email-bookjovi@gmail.com>
Date: Sun, 5 Dec 2010 10:29:02 -0200
Message-ID: <AANLkTimnSPSEx+B+wgxJaaAO8-HxcnLW+Nob4O3mjxBn@mail.gmail.com>
Subject: Re: [PATCH] perf_event: fix error handling path
From: Thiago Farina <tfransosi@gmail.com>
To: bookjovi@gmail.com
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 4, 2010 at 1:19 AM,  <bookjovi@gmail.com> wrote:
> fix error handling path
>
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
>  kernel/perf_event.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index cb6c0d2..62f9e9d 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -1918,8 +1918,6 @@ static int get_callchain_buffers(void)
>        }
>
>        err = alloc_callchain_buffers();
> -       if (err)
> -               release_callchain_buffers();

Care to explain in the change log message? As I reader, is not clear
to me what is wrong with this.
