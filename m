Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab2LUD7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 22:59:40 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:44094 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LUD7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 22:59:17 -0500
MIME-Version: 1.0
In-Reply-To: <12351296.YKgNhoGAuR@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan>
	<1855256.SyhOJGYMIh@vostro.rjw.lan>
	<CAE9FiQXn9C4_eYUdSew-5H0fpHE7C0wCqsXORfrPvGFf2sK98A@mail.gmail.com>
	<12351296.YKgNhoGAuR@vostro.rjw.lan>
Date: Thu, 20 Dec 2012 19:59:15 -0800
X-Google-Sender-Auth: FVYhAsjYLOubak7TfPrOo2j5pns
Message-ID: <CAE9FiQUO16M+_HG7=adYN1B8GpMgL3_rEzCtp5MjGcw2enMw_Q@mail.gmail.com>
Subject: Re: [PATCH 0/16] ACPI: Rework ACPI namespace scanning for devices
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 4:09 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, December 19, 2012 06:06:57 PM Yinghai Lu wrote:
>> On Wed, Dec 19, 2012 at 5:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> great!, the .bind and .unbind go away.
>>
>> >
>> > The patches are on top of my master branch and I'm going to rebase them when
>> > v3.8-rc1 is out.
>>
>> >
>> > There is a git tree you can pull them from at:
>> >
>> > http://git.kernel.org/?p=linux/kernel/git/rafael/linux-pm.git;a=summary acpi-scan-temp-new
>> >
>> > It's v3.7 with my master branch merged and the new patches on top.
>>
>>
>> can you make it base to today's Linus tree ?
>
> Sure.  Rebased and pushed out:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git acpi-scan-next
>

Thanks.

I rebased pci-root-bus-hotplug patchset on top it, and it works well.

So
Acked-by: Yinghai Lu <yinghai@kernel.org>
for the four new ones in your acpi_scan_next branch.

i put the updated patches in

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-pci-root-bus-3.9
