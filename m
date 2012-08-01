Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab2HAJxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:53:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab2HAJxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:53:40 -0400
Message-ID: <5018FC9B.8040808@redhat.com>
Date: Wed, 01 Aug 2012 12:53:31 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
CC: mtosatti@redhat.com, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: KVM segfaults with 3.5 while installing ubuntu 12.04
References: <5017C8A0.60506@profihost.ag> <5017F19E.4070308@redhat.com> <501817C9.6090405@profihost.ag> <5018EC7D.9090702@redhat.com> <5018F5BB.9070500@profihost.ag> <5018F7E6.4020909@redhat.com> <5018F9F6.70307@profihost.ag>
In-Reply-To: <5018F9F6.70307@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 12:42 PM, Stefan Priebe - Profihost AG wrote:
> Am 01.08.2012 11:33, schrieb Avi Kivity:
>>> So here are 3 backtraces from booting the rescue system:
>>> http://pastebin.com/raw.php?i=xCy2pEcP
>>>
>>> To me they all look the same.
>>
>> They are.  What version of qemu are you using?
> 
> latest stable-1.1 branch (1.1.1) - which works fine with latest RHEL6
> kernel.

This could be due to a kernel bug, or due to a different code path taken
in qemu because of differing features exposed to kvm.

Please try qemu-kvm.git master and report.


-- 
error compiling committee.c: too many arguments to function
