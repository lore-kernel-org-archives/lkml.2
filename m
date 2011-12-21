Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab1LUGVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 01:21:53 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58725 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab1LUGVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 01:21:51 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Minchan Kim" <minchan@kernel.org>, "Joe Perches" <joe@perches.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmalloc: remove #ifdef in function body
References: <1324444679-9247-1-git-send-email-minchan@kernel.org>
 <1324445481.20505.7.camel@joe2Laptop>
 <20111221054531.GB28505@barrios-laptop.redhat.com>
 <1324447099.21340.6.camel@joe2Laptop>
Date: Wed, 21 Dec 2011 07:21:42 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v6ttagny3l0zgt@mpn-glaptop>
In-Reply-To: <1324447099.21340.6.camel@joe2Laptop>
User-Agent: Opera Mail/11.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 06:58:19 +0100, Joe Perches <joe@perches.com> wrote:

> On Wed, 2011-12-21 at 14:45 +0900, Minchan Kim wrote:
>> I feel it's no problem as it is because it's very short function now
>> but it's not style we prefer.

> Who is this "we" you refer to?
>
> There's nothing suggesting your patch as a preferred style
> in Documentation/CodingStyle.

There is plenty that is not documented, ;) yet it seems the community prefers
having ifdefs outside of the function.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
