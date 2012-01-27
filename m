Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2A0Eml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:42:41 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55012 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab2A0Em2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:42:28 -0500
Message-ID: <4F222B2B.6010602@gmail.com>
Date: Fri, 27 Jan 2012 12:42:19 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Xiaotian Feng <xtfeng@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sched: Accelerate "pick_next_entity" under special
 condition
References: <4F13EFBE.1030002@linux.vnet.ibm.com> <1326707503.2442.219.camel@twins> <4F14DEAE.60702@linux.vnet.ibm.com> <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com> <4F14E54E.80904@linux.vnet.ibm.com> <1327506934.2614.87.camel@laptop> <20120126100429.GA3853@elte.hu> <4F21FC69.6040402@linux.vnet.ibm.com>
In-Reply-To: <4F21FC69.6040402@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 09:22 AM, Michael Wang wrote:
> Hi, Ingo
>
> Thanks for your reply.
>
> I have try use "ls -l" to see the size of sched.o, but after applied the
> patch, it is still 1636.
>
> I have not use this method before, may be I use the wrong command...
>
> But I think the new code should be similar to the old one after compile,
> because we still have 3 condition check here.
>
> I suppose the new sched.o will be a little bigger, because one jump
> command and a label need to be added.
>

Try to see if `size` helps.
