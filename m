Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815Ab2CNK45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:56:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58177 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab2CNK4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:56:55 -0400
X-IronPort-AV: E=Sophos;i="4.73,583,1325433600"; 
   d="scan'208";a="4533802"
Message-ID: <4F6079E7.7010608@cn.fujitsu.com>
Date: Wed, 14 Mar 2012 18:58:47 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Amit Shah <amit.shah@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F58664D.1070800@cn.fujitsu.com> <4F58943E.1050402@redhat.com> <4F595B31.9090301@cn.fujitsu.com> <4F5DBC26.7060204@cn.fujitsu.com> <4F5DD0FD.9070904@redhat.com> <20120313091843.GB3800@redhat.com> <4F5F25BF.7060100@redhat.com> <4F6056FE.3020202@cn.fujitsu.com> <4F6063C8.8010005@redhat.com> <4F606A7C.9090900@cn.fujitsu.com> <20120314103755.GD2708@amit.redhat.com> <4F607857.50402@cn.fujitsu.com> <4F60788A.2070608@redhat.com>
In-Reply-To: <4F60788A.2070608@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-14 18:54:51,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-14 18:54:52,
	Serialize complete at 2012-03-14 18:54:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/14/2012 06:52 PM, Avi Kivity Wrote:
> On 03/14/2012 12:52 PM, Wen Congyang wrote:
>>>
>>>> If so, is this channel visible to guest userspace? If the channle is visible to guest
>>>> userspace, the program running in userspace may write the same message to the channel.
>>>
>>> Access control is via permissions.  You can have udev scripts assign
>>> whatever uid and gid to the port of your interest.  By default, all
>>> ports are only accessible to the root user.
>>
>> We should also prevent root user writing message to this channel if it is
>> used for panicked notification.
>>
> 
> Why?  root can easily cause a panic.
> 

root user can write the same message to virtio-serial while the guest is running...

Thanks
Wen Congyang
