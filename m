Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554Ab0GQA1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 20:27:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57916 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab0GQA1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 20:27:49 -0400
MIME-Version: 1.0
In-Reply-To: <1279296714-11916-1-git-send-email-chihau@gmail.com>
References: <1279296714-11916-1-git-send-email-chihau@gmail.com>
Date: Fri, 16 Jul 2010 17:27:47 -0700
X-Google-Sender-Auth: CLgB9_QbnyY07X9cj6KC08NJ1vo
Message-ID: <AANLkTinDZSlwpmdKBbC_V8t-Noe9LeHwIJ-1RkAm6p3w@mail.gmail.com>
Subject: Re: [PATCH] Security: capability: code style issue
From: "Andrew G. Morgan" <morgan@kernel.org>
To: Chihau Chau <chihau@gmail.com>
Cc: jmorris@namei.org, eparis@redhat.com, serue@us.ibm.com,
        penguin-kernel@i-love.sakura.ne.jp, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cheers

Acked-by: Andrew G. Morgan <morgan@kernel.org>

On Fri, Jul 16, 2010 at 9:11 AM, Chihau Chau <chihau@gmail.com> wrote:
> From: Chihau Chau <chihau@gmail.com>
>
> This fix a little code style issue deleting a space between a function
> name and a open parenthesis.
>
> Signed-off-by: Chihau Chau <chihau@gmail.com>
> ---
>  security/capability.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/security/capability.c b/security/capability.c
> index 8168e3e..1383ad2 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -27,7 +27,7 @@ static int cap_quota_on(struct dentry *dentry)
>        return 0;
>  }
>
> -static int cap_bprm_check_security (struct linux_binprm *bprm)
> +static int cap_bprm_check_security(struct linux_binprm *bprm)
>  {
>        return 0;
>  }
> --
> 1.5.6.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
