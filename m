Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1E3GiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 02:38:24 -0400
Received: from daytona.panasas.com ([67.152.220.89]:58759 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab1E3GiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 02:38:23 -0400
Message-ID: <4DE33B58.5030204@panasas.com>
Date: Mon, 30 May 2011 09:38:16 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110430 Remi/fc12 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc1
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com> <BANLkTinsO2=tO_UyzzgeU6LE1fObgq+p1Q@mail.gmail.com>
In-Reply-To: <BANLkTinsO2=tO_UyzzgeU6LE1fObgq+p1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2011 06:38:22.0722 (UTC) FILETIME=[2BE36E20:01CC1E94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2011 04:47 AM, Linus Torvalds wrote:
> Oh, and as some people already noticed, the numbering means that the
> tar-balls and patches are now in a new directory:
> 
>     /pub/linux/kernel/v3.0
> 
> (under "testing/", since that's what we do with -rc releases).
> However, I did *not* rename the git tree, because that would just be a
> huge inconvenience to git users, so it's still in the same old place
> and yes, that means that my git tree is still called "linux-2.6.git"
> on kernel.org. But it has the v3.0-rc1 tag in it.
> 
> I'll probably add a symlink or something, if people really hate being
> reminded about our long history with the "2.6" numbering. But that
> won't be until closer to the real release, methinks.
> 
>                             Linus

If you are leaving the three digits system, then I still think my system
was the best. Perhaps you have not seen it?

D.Y.N

D = the decade from 1991. So it always changes on 20?1

Y = The year in the decade. Since it all started in 1991 then
    1 <= Y <= 10. To also denote that we never have a zero version

N = The release number of that year. Also start from 1.
    1 <= Y <= 5

Y and D gets advanced not in the first release of the year around
march, but on the last release of the Year the one close to Christmas

So this Kernel is 3.1.3, then 3.1.4 3.2.1 ... 3.10.4, 4.1.1 and so
on. Always beautiful numbers. single increment, the one that knows
can easily calculate the date it was released.

Also alternatively the middle number (Y) can jump every two years
so 1 <= Y <= 5 and 1 <= N <= 9 to make it more even

If you read this and ignored it for been boring then I apologize.
I thought that your original idea was to drop a digit, but if it is
here to stay, then perhaps this is a good way to fight it back.

Cheers
Boaz
