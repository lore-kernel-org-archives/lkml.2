Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0EaA50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 20:57:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64616 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab0EaA5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 20:57:24 -0400
Message-ID: <4C030A00.8070304@cn.fujitsu.com>
Date: Mon, 31 May 2010 08:59:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, Greg Thelen <gthelen@google.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: alloc_css_id() increments hierarchy depth
References: <1275059781-9831-1-git-send-email-gthelen@google.com>	<AANLkTino0k-wok9kXLmWTyr40dZKSCnR0Uk41uxAj5k1@mail.gmail.com> <20100531084529.2b1f0d25.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100531084529.2b1f0d25.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07:45, KAMEZAWA Hiroyuki wrote:
> On Fri, 28 May 2010 15:25:08 -0700
> Paul Menage <menage@google.com> wrote:
> 
>> On Fri, May 28, 2010 at 8:16 AM, Greg Thelen <gthelen@google.com> wrote:
>>> Signed-off-by: Greg Thelen <gthelen@google.com>
>> Acked-by: Paul Menage <menage@google.com>
>>
>> Good catch, thanks.
>>
> Nice Catch.
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> But, who breaks this ? Do we need backport this against old kernels ?
> 

Oops, I broke it, and it needs to be backported to 2.6.34..
Thanks for catching this!

Acked-by: Li Zefan <lizf@cn.fujitsu.com>
