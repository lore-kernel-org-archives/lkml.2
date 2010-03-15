Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936384Ab0COOJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:09:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:48475 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933841Ab0COOJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:09:39 -0400
Date: Mon, 15 Mar 2010 15:09:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Thomas Weber <weber@corscience.de>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Markus Heidelberg <markus.heidelberg@web.de>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Trivial: Scripts: kconfig: util: Fix typo in comment
In-Reply-To: <1266579824-14706-1-git-send-email-weber@corscience.de>
Message-ID: <alpine.LNX.2.00.1003151509190.18642@pobox.suse.cz>
References: <1266579824-14706-1-git-send-email-weber@corscience.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Feb 2010, Thomas Weber wrote:

> sting replaced with string
> 
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
>  scripts/kconfig/util.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/kconfig/util.c b/scripts/kconfig/util.c
> index b6b2a46..25d1ec4 100644
> --- a/scripts/kconfig/util.c
> +++ b/scripts/kconfig/util.c
> @@ -72,7 +72,7 @@ int file_write_dep(const char *name)
>  }
>  
>  
> -/* Allocate initial growable sting */
> +/* Allocate initial growable string */
>  struct gstr str_new(void)
>  {
>  	struct gstr gs;

Doesn't seem to be present in linux-next as of today. I have picked that 
up.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
