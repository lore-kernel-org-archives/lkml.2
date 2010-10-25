Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab0JYJ4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:56:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab0JYJ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=iOxlAeCyVmKXVy2r8uE5MXWzdo5l6j1W9Kj2ApNmdOWkh4swqltP3IKv6B8ZnuFRxx
         DdxeX/55bMHCwcYMghXn1d6MS0nmeeIxDPROyRcQn7J9Ye14ZpIu64AZ557GANyQ9u9T
         f/OCyoUffsada1Ob7Wisq4DSykdYxr4oZyuRw=
Message-ID: <4CC55436.4010302@gmail.com>
Date: Mon, 25 Oct 2010 11:56:06 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: "Artem S. Tashkinov" <t.artem@lycos.com>
CC: kevin granade <kevin.granade@gmail.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: On Linux numbering scheme
References: <234909.335371287999912985.JavaMail.root@mail-zbox20.bo3.lycos.com>
In-Reply-To: <234909.335371287999912985.JavaMail.root@mail-zbox20.bo3.lycos.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2010 11:45 AM, Artem S. Tashkinov wrote:
> That's my point. "2.6" prefix is totally meaningless nowadays. I just
> want to rejuvenate the numbering scheme and make it easy to understand
> and comprehend. What's the difference between .16 and .36? Besides, I
> just think these huge numbers look unsightly. Do you know any other
> piece of software which has the same huge numbers?

Well, there's no difference between 16 and 36, so what would be the
rationale for changing it?  The only reason is that it's unsightly and
uncommon, but, if you ask me, 36 is _much_ closer to 42 and so is
_much_ better.  The glory days of kernel 42 are coming.  Lo and
behold.

Also, it costs to change numbering scheme.  Think about all the
scripts, distros, poor admins and technical writers (and the dolphins
and fishes).  If 2.6. is too ugly and useless, let's let it wither
away in places it doesn't matter.  No reason to cause disruption
without any real benefit.

Thanks.

-- 
tejun
