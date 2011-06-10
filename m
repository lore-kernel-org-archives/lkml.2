Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1FJIEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:04:42 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19492 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1FJIEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:04:37 -0400
Date: Fri, 10 Jun 2011 09:56:18 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH] sysctl: remove impossible condition check
In-Reply-To: <1307684165-14742-1-git-send-email-lucas.demarchi@profusion.mobi>
Message-ID: <alpine.LNX.2.00.1106100955280.19998@swampdragon.chaosbits.net>
References: <1307030444-7095-1-git-send-email-lucas.demarchi@profusion.mobi> <1307684165-14742-1-git-send-email-lucas.demarchi@profusion.mobi>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011, Lucas De Marchi wrote:

> Remove checks for conditions that will never happen. If procname is NULL
> the loop would already had bailed out, so there's no need to check it
> again.
> 
> At the same time this also compacts the function find_in_table() by
> refactoring it to be easier to read.
> 
> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>

Looks good to me.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

