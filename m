Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab0IHGuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:50:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43940 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab0IHGuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:50:05 -0400
Message-ID: <4C8731D2.1030002@oracle.com>
Date: Wed, 08 Sep 2010 14:48:50 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [GIT PULL] ocfs2 fixes for 2.6.36.
References: <20100907234114.GD21935@mail.oracle.com> <AANLkTi=VaR=UUYh3hzKdD+tvKuuTCD4b4qufQ03AWWxQ@mail.gmail.com>
In-Reply-To: <AANLkTi=VaR=UUYh3hzKdD+tvKuuTCD4b4qufQ03AWWxQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 09/08/2010 10:19 AM, Linus Torvalds wrote:
> On Tue, Sep 7, 2010 at 4:41 PM, Joel Becker<boel.becker@oracle.com>  wrote:
>>
>>         Here are the ocfs2 fixes we have ready for pulling right now.  I
>> have a bit of a procedural question, though.  I've been busy, so Tao was
>> kind enough to take the fixes I already had and apply all the new fixes.
>> He coordinated testing them and getting them ready to go upstream.
>> That's why I have his git tree in the pull request below.
>>         I wasn't sure how the signoffs work for this.  He's got signoffs
>> on the stuff he put together, because it's coming through his tree.  My
>> naive assumption is that this is the correct way to go.
>
> The sign-off chain should basically stretch from the author to the
> committer - so a good sign-off chain is one where the first sign-off
> matches the author of the commit, and the last sign-off matches the
> committer, and the ones in the middle are obviously the path it took
> from one to the other.
>
> However, Tao has *NOT* added sign-offs to the patches he's taken. I
> didn't look at all of them, but the first few commits are all authored
> (and signed off on - so far so good) by Mark Fasheh, but there is no
> sign-off for Tao. So the sign-off chain is clearly not complete.
sorry for the trouble. This is the first time for me to collect patches 
for a mainline upstream.
So I have added my sign-off to all the patches whose author isn't me to 
indicate that I am the committer. Hope it works. please pull
git://oss.oracle.com/git/tma/linux-2.6.git fixes


REgards,
Tao
