Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab1EIU2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:28:53 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19613 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab1EIU2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:28:51 -0400
Date: Mon, 9 May 2011 22:21:54 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Please don't hijack patches - even trivial ones (was: Re: [PATCH
 13/14] HPFS: Move declaration up, so that there are no out-of-scope
 pointers=
In-Reply-To: <alpine.DEB.2.00.1105082031050.7013@artax.karlin.mff.cuni.cz>
Message-ID: <alpine.LNX.2.00.1105092215450.19722@swampdragon.chaosbits.net>
References: <alpine.DEB.2.00.1105082031050.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 May 2011, Mikulas Patocka wrote:

> Move declaration up, so that there are no out-of-scope pointers
> 
> Reported-by: Jesper Juhl <jj@chaosbits.net>
> Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
> 

Hmm. I'm a little currious how my original Signed-off-by got turned into a 
Reported-by for this patch?

This patch is *exactely* the one I submitted on Dec 24 in a message with 
Message-ID: <alpine.LNX.2.00.1012242020090.28973@swampdragon.chaosbits.net>

Ok, it's a trivial little thing, but still. When the patch is completely 
unchanged I think it's a little steep to change the original authors 
Signed-off-by and essentially claim authorship of the patch for one self.


> ---
>  fs/hpfs/ea.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.39-rc5-fast/fs/hpfs/ea.c
> ===================================================================
> --- linux-2.6.39-rc5-fast.orig/fs/hpfs/ea.c	2011-05-05 01:03:00.000000000 +0200
> +++ linux-2.6.39-rc5-fast/fs/hpfs/ea.c	2011-05-05 01:03:01.000000000 +0200
> @@ -76,6 +76,7 @@ int hpfs_read_ea(struct super_block *s, 
>  	unsigned pos;
>  	int ano, len;
>  	secno a;
> +	char ex[4 + 255 + 1 + 8];
>  	struct extended_attribute *ea;
>  	struct extended_attribute *ea_end = fnode_end_ea(fnode);
>  	for (ea = fnode_ea(fnode); ea < ea_end; ea = next_ea(ea))
> @@ -93,7 +94,6 @@ int hpfs_read_ea(struct super_block *s, 
>  	ano = fnode->ea_anode;
>  	pos = 0;
>  	while (pos < len) {
> -		char ex[4 + 255 + 1 + 8];
>  		ea = (struct extended_attribute *)ex;
>  		if (pos + 4 > len) {
>  			hpfs_error(s, "EAs don't end correctly, %s %08x, len %08x",
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

