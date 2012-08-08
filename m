Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab2HHI3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:29:42 -0400
Received: from mail.profihost.ag ([85.158.179.208]:38037 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab2HHI3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:29:40 -0400
Message-ID: <50222370.1030807@profihost.ag>
Date: Wed, 08 Aug 2012 10:29:36 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com, kvm@vger.kernel.org,
        qemu-devel <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Wolf <kwolf@redhat.com>
Subject: Re: KVM segfaults with 3.5 while installing ubuntu 12.04
References: <5018FC9B.8040808@redhat.com> <501E4615.7060801@profihost.ag> <501E4AFD.3020806@redhat.com> <501E96BB.5060702@profihost.ag> <501EC2E2.8010802@profihost.ag> <501F8226.9090500@redhat.com> <501F846C.50903@profihost.ag> <501FB4A8.6080609@redhat.com> <501FBAA2.6050205@redhat.com> <5021FE4B.5070701@profihost.ag> <20120808080657.GA16887@stefanha-thinkpad.localdomain>
In-Reply-To: <20120808080657.GA16887@stefanha-thinkpad.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ah OK - thanks. Will there be a fixed 1.1.2 as well?

Stefan

Am 08.08.2012 10:06, schrieb Stefan Hajnoczi:
> On Wed, Aug 08, 2012 at 07:51:07AM +0200, Stefan Priebe wrote:
>> Any news? Was this applied upstream?
>
> Kevin is ill.  He has asked me to review and test patches in his
> absence.  When he gets back later this week this will get picked up (and
> included in QEMU 1.2).
>
> Here is the tree, it includes this patch:
>
> https://github.com/stefanha/qemu/commits/for-kevin
>
> Stefan
>
