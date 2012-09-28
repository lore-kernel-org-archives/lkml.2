Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2I1BbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:31:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32817 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2I1BbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:31:16 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5064FDCA.1020504@jp.fujitsu.com>
Date: Fri, 28 Sep 2012 10:30:50 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: <wency@cn.fujitsu.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <rientjes@google.com>,
        <liuj97@gmail.com>, <len.brown@intel.com>, <benh@kernel.crashing.org>,
        <paulus@samba.org>, <minchan.kim@gmail.com>,
        <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] memory-hotplug: add node_device_release
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com> <1348724705-23779-3-git-send-email-wency@cn.fujitsu.com> <CAHGf_=rLMsmAxR5hrDVXjkHAxmupVrmtqE3iq2qu=O9Prp4nSg@mail.gmail.com> <5064EA5A.3080905@jp.fujitsu.com> <CAHGf_=qbBGjTL9oBHz7AM8BAosbzvn_WAGdAzJ8np-nDPN_KFQ@mail.gmail.com>
In-Reply-To: <CAHGf_=qbBGjTL9oBHz7AM8BAosbzvn_WAGdAzJ8np-nDPN_KFQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki-san,

2012/09/28 10:13, KOSAKI Motohiro wrote:
> On Thu, Sep 27, 2012 at 8:07 PM, Yasuaki Ishimatsu
> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>> Hi Kosaki-san,
>>
>>
>> 2012/09/28 5:13, KOSAKI Motohiro wrote:
>>>
>>> On Thu, Sep 27, 2012 at 1:45 AM,  <wency@cn.fujitsu.com> wrote:
>>>>
>>>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>>>
>>>> When calling unregister_node(), the function shows following message at
>>>> device_release().
>>>
>>>
>>> This description doesn't have the "following message".
>>>
>>>
>>
>>>> Device 'node2' does not have a release() function, it is broken and must
>>>> be
>>>> fixed.
>>
>>
>> This is the messages. The message is shown by kobject_cleanup(), when
>> calling
>> unregister_node().
>
> If so, you should quote the message. and don't mix it with your
> subject. Moreover
> your patch title is too silly. "add node_device_release() function" is
> a way. you should
> describe the effect of the patch. e.g. suppress "Device 'nodeXX' does
> not have a release() function" warning.

What you say is correct. We should update subject and changelog.

>
> Moreover, your explanation is still insufficient. Even if
> node_device_release() is empty function, we can get rid of the
> warning.

I don't understand it. How can we get rid of the warning?

> Why do we need this node_device_release() implementation?

I think that this is a manner of releasing object related kobject.

Thanks,
Yasuaki Ishimatsu




