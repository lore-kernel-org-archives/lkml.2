Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab0IBVuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:50:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55549 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0IBVuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:50:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cim5SzCvMmBN7V6X+lPFVT8r1eCqqgqvzQ9+GEOvL1XJzLm5NkuBl9XqgE9VpIUs59
         +1bn6VGw9Uysy7gYUP3okoyoJYwMqGORVBFniSUQIgyEWvwKTYuDvqIYJ5N6b8gJdEef
         4eUUmAz3+yKsJKtk7lEJr1PCVCMWxduB9Jaw0=
MIME-Version: 1.0
In-Reply-To: <1283461606-7803-3-git-send-email-justinmattock@gmail.com>
References: <1283461606-7803-1-git-send-email-justinmattock@gmail.com> <1283461606-7803-3-git-send-email-justinmattock@gmail.com>
From: Matt Turner <mattst88@gmail.com>
Date: Thu, 2 Sep 2010 17:49:50 -0400
Message-ID: <AANLkTikDUUoWSWZhtgGyi3QH6uHJz1Op-inH6_V+e21K@mail.gmail.com>
Subject: Re: [PATCH 02/91] arch/alpha/Kconfig Update broken web addresses in
 the arch directory.
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 5:06 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> The below patch updates a broken web address that is no longer
> working due to company buyout, and/or change of location.
> (Please have a look through, and let me know if any of them
> need to be changed, and I'll resend an updated patch).
>
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
>  arch/alpha/Kconfig |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
> index b9647bb..16ae162 100644
> --- a/arch/alpha/Kconfig
> +++ b/arch/alpha/Kconfig
> @@ -219,7 +219,8 @@ config ALPHA_LX164
>        bool "LX164"
>        help
>          A technical overview of this board is available at
> -         <http://www.unix-ag.org/Linux-Alpha/Architectures/LX164.html>.
> +         <http://web.archive.org/web/*/http://www.unix-ag.org/
> +         Linux-Alpha/Architectures/LX164.html>.
>
>  config ALPHA_LYNX
>        bool "Lynx"
> @@ -483,7 +484,8 @@ config ALPHA_AVANTI
>        help
>          Avanti AS 200, AS 205, AS 250, AS 255, AS 300, and AS 400-based
>          Alphas. Info at
> -         <http://www.unix-ag.org/Linux-Alpha/Architectures/Avanti.html>.
> +         <http://web.archive.org/web/*/http://www.unix-ag.org/Linux-Alpha/
> +         Architectures/Avanti.html>.
>
>  config ALPHA_BROKEN_IRQ_MASK
>        bool
> --
> 1.7.2.1

Hi Justin,
These two links are pretty useless. I think we'd do better to remove
them until we write proper articles for the AlphaLinux.Org Wiki.

Matt
