Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab1BYSTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:19:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60309 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab1BYSTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:19:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GVn2Bc3TBduOAFotS0dsS14aUiihM2m+l3r0RBqFpAerGFdzCiRgP8BqqpoIUjB6Zf
         hqmp23yhy0aypLf4Dsm5la6uooQ+rhKORj6C8EYEI2h4wLJakKFtgPVS070afRwMePYD
         0YUqPLbepMTJa+whurNACW4O10xwkG/AKNOe8=
MIME-Version: 1.0
In-Reply-To: <1298614502-4114-1-git-send-email-justinmattock@gmail.com>
References: <1298614502-4114-1-git-send-email-justinmattock@gmail.com>
Date: Fri, 25 Feb 2011 12:19:11 -0600
Message-ID: <AANLkTimneD0d=qpTq2CMpfvjYuQC2kx1mf2ZnORG32KK@mail.gmail.com>
Subject: Re: [PATCH 17/21]fs:cifs:connect.c remove one to many l's in the word.
From: Steve French <smfrench@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, sfrench@samba.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged into cifs-2.6.git

On Fri, Feb 25, 2011 at 12:15 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> The patch below removes an extra "l" in the word.
>
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
>  fs/cifs/connect.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8d6c17a..ea4a146 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -722,7 +722,7 @@ multi_t2_fnd:
>                sock_release(csocket);
>                server->ssocket = NULL;
>        }
> -       /* buffer usuallly freed in free_mid - need to free it here on exit */
> +       /* buffer usually freed in free_mid - need to free it here on exit */
>        cifs_buf_release(bigbuf);
>        if (smallbuf) /* no sense logging a debug message if NULL */
>                cifs_small_buf_release(smallbuf);
> --
> 1.7.4.1
>
>



-- 
Thanks,

Steve
