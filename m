Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2HEK30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 06:29:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab2HEK3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 06:29:24 -0400
Message-ID: <501E4AFD.3020806@redhat.com>
Date: Sun, 05 Aug 2012 13:29:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stefan Priebe <s.priebe@profihost.ag>
CC: mtosatti@redhat.com, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: KVM segfaults with 3.5 while installing ubuntu 12.04
References: <5017C8A0.60506@profihost.ag> <5017F19E.4070308@redhat.com> <501817C9.6090405@profihost.ag> <5018EC7D.9090702@redhat.com> <5018F5BB.9070500@profihost.ag> <5018F7E6.4020909@redhat.com> <5018F9F6.70307@profihost.ag> <5018FC9B.8040808@redhat.com> <501E4615.7060801@profihost.ag>
In-Reply-To: <501E4615.7060801@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2012 01:08 PM, Stefan Priebe wrote:
> Am 01.08.2012 11:53, schrieb Avi Kivity:
>> On 08/01/2012 12:42 PM, Stefan Priebe - Profihost AG wrote:
>>> Am 01.08.2012 11:33, schrieb Avi Kivity:
>>>>> So here are 3 backtraces from booting the rescue system:
>>>>> http://pastebin.com/raw.php?i=xCy2pEcP
>>>>>
>>>>> To me they all look the same.
>>>>
>>>> They are.  What version of qemu are you using?
>>>
>>> latest stable-1.1 branch (1.1.1) - which works fine with latest RHEL6
>>> kernel.
>>
>> This could be due to a kernel bug, or due to a different code path taken
>> in qemu because of differing features exposed to kvm.
>>
>> Please try qemu-kvm.git master and report.
> 
> qemu-kvm.git master just hangs after the 2nd screen with using 100% CPU
> and doing nothing... so i can't test with qemu-kvm.master

Please provide your command line and I will try to reproduce.

Which iso image are you running?

-- 
error compiling committee.c: too many arguments to function
