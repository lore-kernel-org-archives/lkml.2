Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab2CIBUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 20:20:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:7866 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab2CIBUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 20:20:11 -0500
X-IronPort-AV: E=Sophos;i="4.73,555,1325433600"; 
   d="scan'208";a="4493568"
Message-ID: <4F595B31.9090301@cn.fujitsu.com>
Date: Fri, 09 Mar 2012 09:21:53 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F58664D.1070800@cn.fujitsu.com> <4F58943E.1050402@redhat.com>
In-Reply-To: <4F58943E.1050402@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-09 09:18:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-09 09:18:13,
	Serialize complete at 2012-03-09 09:18:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/08/2012 07:13 PM, Avi Kivity Wrote:
> On 03/08/2012 09:57 AM, Wen Congyang wrote:
>> We can know the guest is paniced when the guest runs on xen.
>> But we do not have such feature on kvm.
>>
>> Another purpose of this feature is: management app(for example:
>> libvirt) can do auto dump when the guest is crashed. If management
>> app does not do auto dump, the guest's user can do dump by hand if
>> he sees the guest is paniced.
>>
>> I touch the hypervisor instead of using virtio-serial, because
>> 1. it is simple
>> 2. the virtio-serial is an optional device, and the guest may
>>    not have such device.
>>
>> Changes from v2 to v3:
>> 1. correct spelling
>>
>> Changes from v1 to v2:
>> 1. split up host and guest-side changes
>> 2. introduce new request flag to avoid changing return values.
> 
> I see no Documentation/ changes.

What shoude be writen into Documentation/? I read the documents under
Documentation/virtual/kvm, not all KVM_EXIT_* are writen in api.txt.
In this patch set, I introduce a new exit_reason: KVM_EXIT_GUEST_PANICKED,
but I donot know where I should write.

Thanks
Wen Congyang
