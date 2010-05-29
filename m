Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab0E2Nqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 09:46:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34826 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab0E2Nq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 09:46:28 -0400
Date: Sat, 29 May 2010 15:46:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: optimize mpage_readpage()
Message-ID: <20100529134625.GC25092@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Changli Gao <xiaosuo@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1275095926-18345-1-git-send-email-xiaosuo@gmail.com>
 <20100529121019.GA25092@liondog.tnic>
 <AANLkTimtX4HSql73IEAwOBqC2-R25713IgfihGR-fQm9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTimtX4HSql73IEAwOBqC2-R25713IgfihGR-fQm9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Changli Gao <xiaosuo@gmail.com>
Date: Sat, May 29, 2010 at 09:26:47PM +0800

> Did the compiler warning appear after applying my patch? It doesn't
> happen when I testing it.

yep, using gcc (Debian 4.4.4-2) 4.4.4 here.

> And I don't pass bio to do_mpage_readpage(), but I pass NULL instead.

True, but you still need that bio pointer so you might just as well set
it to NULL as the original code does.

-- 
Regards/Gruss,
    Boris.
