Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1HNTWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 15:22:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754770Ab1HNTWc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 15:22:32 -0400
MIME-Version: 1.0
In-Reply-To: <1313348706-16093-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1313348706-16093-1-git-send-email-Jes.Sorensen@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 14 Aug 2011 12:22:08 -0700
Message-ID: <CA+55aFw4-3o9rX5z3Jtnim5v3K2LhsGyAbXWVG-8iyeCBjGezA@mail.gmail.com>
Subject: Re: [PATCH] Remove name and email address as maintainer for SN2
To: Jes.Sorensen@redhat.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Umm, shouldn't we mark it as unmaintained in this case?

Or do we have someone who has one of those and is willing to do the
(not very much) to make sure it keeps compiling and booting?

                   Linus

On Sun, Aug 14, 2011 at 12:05 PM,  <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
> ---
>  MAINTAINERS |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1d445f5..79080e0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5921,7 +5921,6 @@ S:        Supported
>  F:     drivers/net/smsc9420.*
>
>  SN-IA64 (Itanium) SUB-PLATFORM
> -M:     Jes Sorensen <jes@sgi.com>
>  L:     linux-altix@sgi.com
>  L:     linux-ia64@vger.kernel.org
>  W:     http://www.sgi.com/altix
> --
> 1.7.4.4
>
>
