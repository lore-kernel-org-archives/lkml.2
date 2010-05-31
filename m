Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0EaA66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 20:58:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52091 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab0EaA65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 20:58:57 -0400
Message-ID: <4C030A5D.2000700@cn.fujitsu.com>
Date: Mon, 31 May 2010 09:01:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: alloc_css_id() increments hierarchy depth
References: <1275059781-9831-1-git-send-email-gthelen@google.com> 	<AANLkTino0k-wok9kXLmWTyr40dZKSCnR0Uk41uxAj5k1@mail.gmail.com> 	<20100531084529.2b1f0d25.kamezawa.hiroyu@jp.fujitsu.com> <20100531085431.a45b30b9.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTilNrrsNluDBUlXCsZMz7d_-VHn31Ogvkw9AUPnE@mail.gmail.com>
In-Reply-To: <AANLkTilNrrsNluDBUlXCsZMz7d_-VHn31Ogvkw9AUPnE@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> On Fri, May 28, 2010 at 8:16 AM, Greg Thelen <gthelen@google.com> wrote:
>>>>> Signed-off-by: Greg Thelen <gthelen@google.com>
>>>> Acked-by: Paul Menage <menage@google.com>
>>>>
>>>> Good catch, thanks.
>>>>
>>> Nice Catch.
>>> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>>
>>> But, who breaks this ? Do we need backport this against old kernels ?
>>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fae9c791703606636c1220e47f6690660042ce7f
>>
>> Hmm. this one. and 2.6.34 needs this patch. Greg, could you post this to
>> stable-2.6.34 tree ?
> 
> Given that I forgot to include "Cc: stable <stable@kernel.org>" in the
> patch, I assume the best way to get this patch into -stable is for me
> to email the commit id to stable@kernel.org once the patch is accepted
> into Linus' tree.  Let me know if there is a better way.
> 

I think Andrew will mark it and send it to stable.
