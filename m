Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab2HJPPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 11:15:03 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59331 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab2HJPO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 11:14:58 -0400
MIME-Version: 1.0
In-Reply-To: <50222370.1030807@profihost.ag>
References: <5018FC9B.8040808@redhat.com>
	<501E4615.7060801@profihost.ag>
	<501E4AFD.3020806@redhat.com>
	<501E96BB.5060702@profihost.ag>
	<501EC2E2.8010802@profihost.ag>
	<501F8226.9090500@redhat.com>
	<501F846C.50903@profihost.ag>
	<501FB4A8.6080609@redhat.com>
	<501FBAA2.6050205@redhat.com>
	<5021FE4B.5070701@profihost.ag>
	<20120808080657.GA16887@stefanha-thinkpad.localdomain>
	<50222370.1030807@profihost.ag>
Date: Fri, 10 Aug 2012 16:14:56 +0100
Message-ID: <CAJSP0QX2Cn_Q0QCjDfiAqgpH2axiDdaLeFg8Aies-kJtCRJ9MQ@mail.gmail.com>
Subject: Re: KVM segfaults with 3.5 while installing ubuntu 12.04
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Michael Roth <mdroth@linux.vnet.ibm.com>
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Avi Kivity <avi@redhat.com>,
        mtosatti@redhat.com, kvm@vger.kernel.org,
        qemu-devel <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Wolf <kwolf@redhat.com>, Stefan Priebe <s.priebe@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 9:29 AM, Stefan Priebe <s.priebe@profihost.ag> wrote:
> ah OK - thanks. Will there be a fixed 1.1.2 as well?

mdroth: Kevin has the fix in his block branch, which means qemu.git
will get it soon.  Here's the commit:

http://repo.or.cz/w/qemu/kevin.git/commit/730a9c53b4e52681fcfe31cf38854cbf91e132c7

>
> Am 08.08.2012 10:06, schrieb Stefan Hajnoczi:
>
>> On Wed, Aug 08, 2012 at 07:51:07AM +0200, Stefan Priebe wrote:
>>>
>>> Any news? Was this applied upstream?
>>
>>
>> Kevin is ill.  He has asked me to review and test patches in his
>> absence.  When he gets back later this week this will get picked up (and
>> included in QEMU 1.2).
>>
>> Here is the tree, it includes this patch:
>>
>> https://github.com/stefanha/qemu/commits/for-kevin
>>
>> Stefan
>>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
