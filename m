Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2EULfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 07:35:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab2EULfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 07:35:04 -0400
Message-ID: <4FBA2864.5010700@suse.cz>
Date: Mon, 21 May 2012 13:35:00 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/3] scripts/patch-kernel: fix typos and compression comment
References: <4FB9AD3C.3040909@xenotime.net>
In-Reply-To: <4FB9AD3C.3040909@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.5.2012 04:49, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix typo, drop trailing whitespace, and add "xz" to list of
> compression types supported.
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  scripts/patch-kernel |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- lnx-34-rc7-pk.orig/scripts/patch-kernel
> +++ lnx-34-rc7-pk/scripts/patch-kernel
> @@ -26,8 +26,8 @@
>  #
>  #       Nick Holloway <Nick.Holloway@alfie.demon.co.uk>, 2nd January 1995.
>  #
> -# Added support for handling multiple types of compression. What includes
> -# gzip, bzip, bzip2, zip, compress, and plaintext. 
> +# Added support for handling multiple types of compression. That includes
> +# gzip, bzip, bzip2, zip, compress, xz, and plaintext.
>  #
>  #       Adam Sulmicki <adam@cfar.umd.edu>, 1st January 1997.

You are editing a changelog entry from time when xz did not exist. Why
don't you instead add a note to the usage examples at the beginning of
the script, that several compression formats are supported.

BTW, are you actually *using* this script? Wow, that would be two
confirmed users in this calendar year alone :).

Michal
