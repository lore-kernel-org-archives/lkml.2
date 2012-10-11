Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232Ab2JKUKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:10:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab2JKUKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:10:40 -0400
Message-ID: <507727BB.9070505@suse.cz>
Date: Thu, 11 Oct 2012 22:10:35 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Yang Bai <hamo.by@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] ignore generated binary file scripts/basic/hash
References: <1349975049-6317-1-git-send-email-hamo.by@gmail.com>
In-Reply-To: <1349975049-6317-1-git-send-email-hamo.by@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 11.10.2012 19:04, Yang Bai napsal(a):
> Signed-off-by: Yang Bai <hamo.by@gmail.com>
> ---
>  scripts/basic/.gitignore |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/scripts/basic/.gitignore b/scripts/basic/.gitignore
> index a776371..b372870 100644
> --- a/scripts/basic/.gitignore
> +++ b/scripts/basic/.gitignore
> @@ -1 +1,2 @@
>  fixdep
> +hash

scripts/basic/hash.c has been removed two years ago.

Michal
