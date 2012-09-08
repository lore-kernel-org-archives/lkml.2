Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2IHRkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:40:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47996 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab2IHRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:40:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120908173234.GB10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120906200802.GI29092@google.com>
	<504965AA.6090107@cn.fujitsu.com>
	<20120907192939.GF9426@google.com>
	<20120907202249.GH9426@google.com>
	<20120907203414.GI9426@google.com>
	<20120907230556.GJ9426@google.com>
	<20120907230746.GK9426@google.com>
	<20120907234158.GL9426@google.com>
	<CACvQF51CEjqx_5pftzf6BwxCtyV8zGsVNBKjKBtt-L_iSxr4iQ@mail.gmail.com>
	<20120908172950.GA10788@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120908173234.GB10788@dhcp-172-17-108-109.mtv.corp.google.com>
Date: Sun, 9 Sep 2012 01:40:19 +0800
Message-ID: <CACvQF50CzHq3xAEwKOqgk=aO3nqn_A-60QEux7Ard9wAG3Akpg@mail.gmail.com>
Subject: Re: [PATCH wq/for-3.6-fixes 3/3] workqueue: fix possible idle worker
 depletion during CPU_ONLINE
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 9, 2012 at 1:32 AM, Tejun Heo <tj@kernel.org> wrote:
> On Sat, Sep 08, 2012 at 10:29:50AM -0700, Tejun Heo wrote:
>> > hotplug code can't iterate manager.  not rebind_work() nor UNBOUND for manager.
>>
>> Ah, right.  It isn't either on idle or busy list.  Maybe have
>> pool->manager pointer?
>
> Ooh, this is what you did with the new patchset, right?

I already did it in V5 patchset. not in new patchset. I just change it
as you like in V6.
I change the strategy of calling may_rebind_manager().

Thanks.
Lai

>
> --
> tejun
