Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915Ab2CUSSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:18:18 -0400
Received: from david.siemens.de ([192.35.17.14]:20824 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759882Ab2CUSSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:18:14 -0400
Message-ID: <4F6A1B4D.2060908@siemens.com>
Date: Wed, 21 Mar 2012 19:17:49 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Daniel P. Berrange" <berrange@redhat.com>,
        "minyard@acm.org" <minyard@acm.org>,
        Corey Minyard <tcminyard@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F58664D.1070800@cn.fujitsu.com> <4F66E14F.3040809@cn.fujitsu.com> <4F6854F4.3060703@cn.fujitsu.com> <20120320154517.GG27928@redhat.com> <4F692723.8050904@cn.fujitsu.com> <20120321091127.GO22368@redhat.com> <4F69FF48.3010200@acm.org> <4F6A00EC.3060706@redhat.com> <20120321170413.GD3101@redhat.com> <4F6A1109.8060209@redhat.com>
In-Reply-To: <4F6A1109.8060209@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-21 18:34, Avi Kivity wrote:
> On 03/21/2012 07:04 PM, Daniel P. Berrange wrote:
>>>
>>> In fact the feature can be implemented 100% host side by searching for a
>>> panic string signature in the console logs.
>>
>> You can even go one better and search for the panic string in the
>> guest memory directly, which is what virt-dmesg does :-)
>>
>>   http://people.redhat.com/~rjones/virt-dmesg/
>>
> 
> -ETOOHACKY
> 
> Any guest change will break this, no?

/me has a simple python script (a few ten lines) to do this during
runtime (kgdb, qemu gdbstub) or post-portem (gdb -c vmcore). Ideally,
that will once come with the Linux sources where it can be kept in sync
with the kernel data structures.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
