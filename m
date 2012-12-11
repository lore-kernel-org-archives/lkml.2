Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2LKPJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 10:09:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53602 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab2LKPJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 10:09:24 -0500
Message-ID: <50C74C92.1040405@gmail.com>
Date: Tue, 11 Dec 2012 23:09:06 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH 5/6] ACPI: Replace struct acpi_bus_ops with enum type
References: <8498184.VilrUmatxI@vostro.rjw.lan> <CAE9FiQWZ8WaAJm8ayU+woVRqNLdSRtPS4=gpsrJovmzrUG6FNw@mail.gmail.com> <38722368.Fl8pJoLSRi@vostro.rjw.lan> <8119513.v7VrlzcaZC@vostro.rjw.lan> <CAE9FiQXYPPcRZZBFGrqcV--0-UixMH1f+q4WdovErthsLhxn7A@mail.gmail.com>
In-Reply-To: <CAE9FiQXYPPcRZZBFGrqcV--0-UixMH1f+q4WdovErthsLhxn7A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,
	I have worked out a patch set to clean up ACPI/PCI related notifications,
please refer to
http://www.spinics.net/lists/linux-pci/msg17822.html
	The patchset doesn't apply cleanly to Bjorn's latest pci-next tree. I will
help to rebase it if needed.
Regards!
Gerry

On 12/11/2012 10:26 AM, Yinghai Lu wrote:
> On Mon, Dec 10, 2012 at 5:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>
>>> OK, thanks for the pointers.  I actually see more differences between our
>>> patchsets.  For one example, you seem to have left the parent->ops.bind()
>>> stuff in acpi_add_single_object() which calls it even drivers_autoprobe is
>>> set.
>>
>> Sorry, that should have been "which calls it even when drivers_autoprobe is
>> not set".  I need to be more careful.
>>
> 
> oh,  Jiang Liu had one patch to remove that workaround.
> 
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=b40dba80c2b8395570d8357e6b3f417c27c84504
> 
> ACPI/pci-bind: remove bind/unbind callbacks from acpi_device_ops
> 
> Maybe you can review that patches in my for-pci-next2...
> those are ACPI related anyway.
> 
> those patches have been there for a while, and Bjorn did not have time
> to digest them.
> 
> or you prefer I resend updated version as huge whole patchset?
> 
> Thanks
> 
> Yinghai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

