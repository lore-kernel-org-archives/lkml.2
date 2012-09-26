Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2IZO6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:58:05 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34145 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab2IZO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:58:03 -0400
MIME-Version: 1.0
In-Reply-To: <5061F7C7.7060107@gmail.com>
References: <20120922155613.GB2934@linux.vnet.ibm.com>
	<505DFA65.3080805@gmail.com>
	<20120922212735.GG2934@linux.vnet.ibm.com>
	<20120923002105.GA1112@linux.vnet.ibm.com>
	<505EA09B.6040105@gmail.com>
	<CAFTL4hwqzS8iO2zOOGaizzMtT85MJExTxEgGbponJ4_gfv0nwA@mail.gmail.com>
	<5060E31B.3070203@gmail.com>
	<5060E498.7030003@gmail.com>
	<CAFTL4hzVSBkcDRnzvpmXyBHqydqy=nJxdMtjUHrvR8MwN_M0jQ@mail.gmail.com>
	<5060E863.6020006@gmail.com>
	<20120925120549.GC2310@somewhere.redhat.com>
	<5061F7C7.7060107@gmail.com>
Date: Wed, 26 Sep 2012 16:58:01 +0200
Message-ID: <CAFTL4hyj43L1b_7B+BjSbdGAE4RNYqFBz01G+ifwKu=0k9v+2w@mail.gmail.com>
Subject: Re: RCU idle CPU detection is broken in linux-next
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Michael Wang <wangyun@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/25 Sasha Levin <levinsasha928@gmail.com>:
> On 09/25/2012 02:06 PM, Frederic Weisbecker wrote:
>> Sasha, sorry to burden you with more testing request.
>> Could you please try out this new branch? It includes some fixes after Wu Fenguang and
>> Dan Carpenter reports (not related to your warnings though) and a patch on the top
>> of the pile to ensure I diagnosed well the problem, which return immediately from
>> rcu_user_*() APIs if we are in an interrupt.
>>
>> This way we'll have a clearer view. I also would like to know if there are other
>> problems with the rcu user mode.
>>
>> Thanks!
>
> Alrighty, I don't see any warnings anymore.
>
> I'll keep everything running just in case.

Cool! I'm pushing the fix tree to Paul then.

Thanks a lot for your testing!
