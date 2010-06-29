Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0F2M5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:57:21 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:45424 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171Ab0F2M5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:57:19 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Kulikov Vasiliy <segooon@gmail.com>
Subject: Re: [PATCH] Documentation: fix ubuntu distro name
Date: Tue, 29 Jun 2010 14:57:13 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: trivial@kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <1277814677-1944-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1277814677-1944-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006291457.13795.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The version in Karmic is too old. The right correction is indeed Lucid Lynx.

On Tuesday 29 June 2010 14:31:16 Kulikov Vasiliy wrote:
> 10.04 is Lucid, not Karmic.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  Documentation/coccinelle.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
> index ba3315d..cd2b028 100644
> --- a/Documentation/coccinelle.txt
> +++ b/Documentation/coccinelle.txt
> @@ -14,7 +14,7 @@ of many distributions, e.g. :
>  
>   - Debian (>=squeeze)
>   - Fedora (>=13)
> - - Ubuntu (>=10.04 Karmic Koala)
> + - Ubuntu (>=10.04 Lucid Lynx)
>   - OpenSUSE
>   - Arch Linux
>   - NetBSD
> 

Acked-by: Nicolas Palix <npalix@diku.dk>

-- 
Nicolas Palix
Tel: (+33) 1 44 27 87 25
Tel: (+33) 6 81 07 91 72
Web: http://www.diku.dk/~npalix/
