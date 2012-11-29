Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab2K2Q4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:56:38 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40920 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2K2Q4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:56:37 -0500
MIME-Version: 1.0
In-Reply-To: <20121129163116.GP27196@axis.com>
References: <20121129163116.GP27196@axis.com>
Date: Thu, 29 Nov 2012 10:56:36 -0600
Message-ID: <CAH2r5mu8UO_tuXSR8kfdD3+EQbJ-3miY9PT4+h6upDHkhzi-PQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add handling of blank password option
From: Steve French <smfrench@gmail.com>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged into cifs-2.6.git

On Thu, Nov 29, 2012 at 10:31 AM, Jesper Nilsson
<jesper.nilsson@axis.com> wrote:
> The option to have a blank "pass=" already exists, and with
> a password specified both "pass=%s" and "password=%s" are supported.
> Also, both blank "user=" and "username=" are supported, making
> "password=" the odd man out.
>
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> ---
>  fs/cifs/connect.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 5c670b9..c83f5b65 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -186,6 +186,7 @@ static const match_table_t cifs_mount_option_tokens = {
>         { Opt_user, "user=%s" },
>         { Opt_user, "username=%s" },
>         { Opt_blank_pass, "pass=" },
> +       { Opt_blank_pass, "password=" },
>         { Opt_pass, "pass=%s" },
>         { Opt_pass, "password=%s" },
>         { Opt_blank_ip, "ip=" },
> --
> 1.8.0.rc0.18.gf84667d
>
>
> /^JN - Jesper Nilsson
> --
>                Jesper Nilsson -- jesper.nilsson@axis.com



-- 
Thanks,

Steve
