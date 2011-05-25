Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab1EYNWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:22:13 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50073 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab1EYNWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:22:12 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jonas Gorski <jonas.gorski@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exportfs: reallow building as a module
In-Reply-To: <1306260728-12031-1-git-send-email-jonas.gorski@gmail.com>
References: <1306260728-12031-1-git-send-email-jonas.gorski@gmail.com>
User-Agent: Notmuch/0.5-145-gb6862c7 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Wed, 25 May 2011 18:52:06 +0530
Message-ID: <87r57mykxt.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011 20:12:08 +0200, Jonas Gorski <jonas.gorski@gmail.com> wrote:
> Commit 990d6c2d7aee921e3bce22b2d6a750fd552262be ("vfs: Add name to file
> handle conversion support") changed EXPORTFS to be a bool.
> This was needed for earlier revisions of the original patch, but the actual
> commit put the code needing it into its own file that only gets compiled
> when FHANDLE is selected which in turn selects EXPORTFS.
> So EXPORTFS can be safely compiled as a module when not selecting FHANDLE.
> 
> Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
> ---
>  fs/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index f3aa9b0..efb7d4e 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -47,7 +47,7 @@ config FS_POSIX_ACL
>  	def_bool n
> 
>  config EXPORTFS
> -	bool
> +	tristate
> 
>  config FILE_LOCKING
>  	bool "Enable POSIX file locking API" if EXPERT

Acked-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

