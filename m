Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0KEPXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 11:23:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948Ab0KEPXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 11:23:08 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011042132480.15349@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011042132480.15349@swampdragon.chaosbits.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Nov 2010 08:22:01 -0700
Message-ID: <AANLkTimMiEX1MGL3xH8rbRhuWtJRsBttFQfTPjj61JHb@mail.gmail.com>
Subject: Re: [PATCH resend] Optimize relay_alloc_page_array() slightly by
 using vzalloc rather than vmalloc and memset
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, relayfs-devel@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@us.ibm.com>, Tom Zanussi <tzanussi@gmail.com>,
        Karim Yaghmour <karim@opersys.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Paul Mundt <lethal@linux-sh.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 4, 2010 at 1:44 PM, Jesper Juhl <jj@chaosbits.net> wrote:
>
> Now I just need to find someone to actually merge it...

Ok, I took it.

         Linus
