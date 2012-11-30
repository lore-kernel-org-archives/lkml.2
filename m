Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2K3WCC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 17:02:02 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34469 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2K3WB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 17:01:57 -0500
MIME-Version: 1.0
In-Reply-To: <50B8ECB3.2090801@schaufler-ca.com>
References: <20121129174057.99da02b15426c76054d05592@canb.auug.org.au>
	<50B7F846.70202@infradead.org>
	<3694027.VYznNcdp7C@sifl>
	<2664553.2TRaVqlkGg@sifl>
	<50B8E4E6.2040901@xenotime.net>
	<50B8ECB3.2090801@schaufler-ca.com>
Date: Fri, 30 Nov 2012 17:01:55 -0500
Message-ID: <CACLa4ptazSZCpk5Ug0mZLZRS1PxZ7KnwYxEXsXFwn3zG90YzNg@mail.gmail.com>
Subject: Re: [PATCH] Smack: Add missing depends on INET in Kconfig
From: Eric Paris <eparis@parisplace.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Paul Moore <paul@paul-moore.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do other LSMs need this too Casey?  I remember we mentioned how select
was dangerous  :-(

On Fri, Nov 30, 2012 at 12:28 PM, Casey Schaufler
<casey@schaufler-ca.com> wrote:
> Because NETLABEL depends on INET SECURITY_SMACK
> has to explicitly call out the dependency.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> ---
>  security/smack/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/security/smack/Kconfig b/security/smack/Kconfig
> index 9fb14ef..1be1088 100644
> --- a/security/smack/Kconfig
> +++ b/security/smack/Kconfig
> @@ -1,5 +1,6 @@
>  config SECURITY_SMACK
>         bool "Simplified Mandatory Access Control Kernel Support"
> +       depends on INET
>         depends on NET
>         depends on SECURITY
>         select NETLABEL
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
