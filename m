Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2HHJXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:23:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40309 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab2HHJXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:23:49 -0400
X-IronPort-AV: E=Sophos;i="4.77,732,1336320000"; 
   d="scan'208";a="5580088"
Message-ID: <50223156.3030803@cn.fujitsu.com>
Date: Wed, 08 Aug 2012 17:28:54 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v8] kvm: notify host when the guest is panicked
References: <5021D235.4050800@cn.fujitsu.com> <20120808091235.GA2663@turtle.usersys.redhat.com>
In-Reply-To: <20120808091235.GA2663@turtle.usersys.redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/08 17:24:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/08 17:24:10,
	Serialize complete at 2012/08/08 17:24:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 08/08/2012 05:12 PM, Andrew Jones Wrote:
> On Wed, Aug 08, 2012 at 10:43:01AM +0800, Wen Congyang wrote:
>> diff --git a/Documentation/virtual/kvm/pv_event.txt b/Documentation/virtual/kvm/pv_event.txt
>> new file mode 100644
>> index 0000000..0ebc890
>> --- /dev/null
>> +++ b/Documentation/virtual/kvm/pv_event.txt
>> @@ -0,0 +1,32 @@
>> +The KVM paravirtual event interface
>> +=================================
>> +
>> +Initializing the paravirtual event interface
>> +======================
>> +kvm_pv_event_init()
>> +Argiments:
>> +	None
>> +
>> +Return Value:
>> +	0 : The guest kernel can't use paravirtual event interface.
>> +	-1: The guest kernel can use paravirtual event interface.
>> +
> 
> This documentation has the can and can't backwards.
> 

Yes, I will fix it.

Thanks
Wen Congyang
