Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2J3Aqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 20:46:43 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39335 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2J3Aql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 20:46:41 -0400
Message-ID: <508F2354.3090801@gmail.com>
Date: Tue, 30 Oct 2012 11:46:12 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>, arm@kernel.org
Subject: Re: [PULL REQ] IXP4xx changes for Linux 3.7
References: <m3bog6m5iz.fsf@intrepid.localdomain> <201210142002.55841.arnd@arndb.de> <m3a9vkahci.fsf@intrepid.localdomain>
In-Reply-To: <m3a9vkahci.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/10/12 09:01, Krzysztof Halasa wrote:
> Hi,
> 

<snip>

> 
> Unfortunately, as I already explained to you in
> https://lkml.org/lkml/2012/9/29/37, my resources for IXP4xx are very
> limited (and this isn't a paid job) and I'm in no way able to do what
> you require. This, coupled with my inability to make the patches end up
> upstream any other way, will make me post relevant MAINTAINERS changes
> shortly.
> 
> Don't get me wrong. If I had time for this it could be different.
> Unfortunately IXP4xx is a legacy arch, and for me it's simply a hobby at
> this point. Given the raised barriers to participate, probably aimed at
> paid maintainers, I have to quit doing this.
> 
> BTW since Imre has probably even much less time, it would be a good time
> to find someone to maintain IXP4xx code. I will be publishing (from time
> to time) my tree (I'm using the hw myself), so even simple
> cherry-picking would probably make some sense.

I maintain a tree for the ep93xx, which is another legacy arm soc. I
also do this as a hobbyist, not as a paid position. Pushing patches to
mainline via arm-soc has been very easy. Basically I branch from Linus's
tree (typically 3.x-rc1), apply patches to one of a bunch of branches
(-devel, -fixes, etc) and then send pull requests to the arm-soc
maintainers prior to the merge window. I also have a aggregate branch
which is tested in next.

It takes very little of my time to maintain this tree. I cannot see how
it could be any harder than sending to Linus directly. Also, the arm-soc
maintainers, Arnd and Olof, have been very helpful in getting me started
with my maintainer tree, and in learning the development flow.

I would also rather get flamed by the arm-soc guys than Linus when I
make a mistake :-).

~Ryan

