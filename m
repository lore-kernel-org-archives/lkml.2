Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043Ab2CGDAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 22:00:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:47409 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756144Ab2CGDA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 22:00:29 -0500
X-IronPort-AV: E=Sophos;i="4.73,543,1325433600"; 
   d="scan'208";a="4476387"
Message-ID: <4F56CBB6.90100@cn.fujitsu.com>
Date: Wed, 07 Mar 2012 10:45:10 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Eric Blake <eblake@redhat.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v2] deal with guest paniced event
References: <4F56BEF2.4020405@cn.fujitsu.com> <4F56C0E1.1090703@cn.fujitsu.com> <4F56CA9E.2040907@redhat.com>
In-Reply-To: <4F56CA9E.2040907@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 10:41:32,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 10:41:38,
	Serialize complete at 2012-03-07 10:41:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/07/2012 10:40 AM, Eric Blake Wrote:
> On 03/06/2012 06:58 PM, Wen Congyang wrote:
>> When the host knows the guest is paniced, it will set
>> exit_reason to KVM_EXIT_GUEST_PANICED. So if qemu receive
>> this exit_reason, we can send a event to tell management
>> application that the guest is paniced and set the guest
>> status to RUN_STATE_PANICED.
> 
> s/PANICED/PANICKED/ throughout your series, for the correct spelling of
> the past tense of panic.

Sorry for my bad english. I will update it.

Thanks
Wen Congyang

> 

