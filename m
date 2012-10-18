Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab2JRAxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 20:53:36 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:4723 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab2JRAxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 20:53:34 -0400
Message-ID: <507F52A1.1030800@huawei.com>
Date: Thu, 18 Oct 2012 08:51:45 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 00/40] PCI, ACPI, x86: pci root bus hotplug support
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com> <1348080894-23412-1-git-send-email-yinghai@kernel.org> <507E6355.40904@huawei.com> <CAE9FiQWW2zMK0fQ1RGox653PNxoH_RY_X8N4Oh_osu8Pt9gWpg@mail.gmail.com>
In-Reply-To: <CAE9FiQWW2zMK0fQ1RGox653PNxoH_RY_X8N4Oh_osu8Pt9gWpg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.84]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/10/18 0:19, Yinghai Lu wrote:
> On Wed, Oct 17, 2012 at 12:50 AM, Yijing Wang <wangyijing@huawei.com> wrote:
>> On 2012/9/20 2:54, Yinghai Lu wrote:
>>
>> Hi Yinghai,
>>    I applied this series patches to the latest pci-next, but git am fail occured.
>> When I try to pull from for-pci-root-bus-hotplug branch, I found some patches missed(eg. SCI_EMULATE).
>> Where can I get the newest pci root bus hotplug patches?
> 
> should be
> for-pci-split-pci-root-hp-2
> or
> for-pci-next-2
> branch.
> 
> but
>>> part6: acpi add/remove simulation
>>> [PATCH 40/40] ACPI: Enable SCI_EMULATE to manually simulate physical
> 
> is not in. you need to apply that separately.
> 

OK, Thanks!

> .
> 


-- 
Thanks!
Yijing

