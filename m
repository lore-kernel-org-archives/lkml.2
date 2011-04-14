Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab1DNMcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 08:32:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42525 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330Ab1DNMcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 08:32:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=iU2n/bdG+gCjYZS5xWiGVCETcvyxIe7fX5qiQ6YgyInqtHaQnSirZjVP28CLmiIGyB
         angk+vGysL/V6OGGE0wtNpB0OQC99Aj6cO8cEjcuSoT0+BAPUc5eWGtoInwNrlCYMAJ5
         umJ6vyiwh+cYsXmXhH5C5aG0sqTJ0RJCMIcIY=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: =?utf-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        "Pintu Agarwal" <pintu_agarwal@yahoo.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Changli Gao" <xiaosuo@gmail.com>, "Jiri Slaby" <jslaby@suse.cz>,
        azurIt <azurit@pobox.sk>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: Regarding memory fragmentation using malloc....
References: <858878.89812.qm@web162015.mail.bf1.yahoo.com>
Date: Thu, 14 Apr 2011 14:31:57 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vtxg3jzl3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <858878.89812.qm@web162015.mail.bf1.yahoo.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 14:24:56 +0200, Pintu Agarwal  
<pintu_agarwal@yahoo.com> wrote:

> Sorry. There was a small typo in my last sentence (mitigating not  
> *migitating* memory fragmentation)
> That means how can I measure the memory fragmentation either from user  
> space or from kernel space.
> Is there a way to measure the amount of memory fragmentation in linux?

I'm still not entirely sure what you need.  You may try to measure
fragmentation by the number of low order pages -- the more low order
pages compared to high order pages the bigger the fragmentation.

As of how to mitigate...  There's memory compaction.  There's some
optimisations in buddy system.  I'm probably not the best person to
ask anyway.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
