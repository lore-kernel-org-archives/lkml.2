Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab2INLwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:52:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63190 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab2INLwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:52:02 -0400
Message-ID: <50531A5D.3010206@gmail.com>
Date: Fri, 14 Sep 2012 05:51:57 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Dong Hao <haodong@linux.vnet.ibm.com>, acme@infradead.org, avi@redhat.com,
        mtosatti@redhat.com, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 3/3] KVM: perf: kvm events analysis tool
References: <1346061106-5364-1-git-send-email-haodong@linux.vnet.ibm.com> <1346061106-5364-4-git-send-email-haodong@linux.vnet.ibm.com> <503FB105.9000205@gmail.com> <5051678C.1070209@gmail.com> <50529CCB.1040708@linux.vnet.ibm.com>
In-Reply-To: <50529CCB.1040708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/12 8:56 PM, Xiao Guangrong wrote:
> We'd better keep the record/report function, sometimes, we can only get perf.data
> from the customers whose machine can not be reached for us.
>
> Especially, other tracepoints are also interesting for us when the customers encounter
> the performance issue, we always ask costumes to use "perf kvm stat -e xxx" to append
> other events, like lock:*. Then, we can get not only the information of kvm events
> by using 'perf kvm stat' but also other informations like 'perf lock' or 'perf script'
> to get the whole sequences.

Ok.

> And, i think "live mode" is also useful for 'perf lock/sched', could you implement it
> in perf core?

The code will be re-usable, so lock and sched should be able to add a 
live mode too.

>
> By the way, the new version of our patchset is ready, do you want to add your implement
> after it is accepted by Arnaldo? Or are you going to post it with our patchset together?

Then go ahead and submit it for inclusion; I'll add my stuff on top.

David
