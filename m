Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2IXWjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:39:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63046 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2IXWjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:39:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWi46m4rP9chVK0W5ahtgk7cuCO60dTYzP6JVM=x=5abA@mail.gmail.com>
References: <20120922003557.GF5959@localhost> <CAE9FiQVQJQfBZn7AH4M5hibx=iNa9RbfSaBdb35FWxDiRXHvrA@mail.gmail.com>
 <CAE9FiQVQMVsqG2vHhyktTtUSJ_dDRpTpwB_x--agMWbm6PHsEg@mail.gmail.com>
 <20120922081009.GA5677@localhost> <CAE9FiQWi46m4rP9chVK0W5ahtgk7cuCO60dTYzP6JVM=x=5abA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 24 Sep 2012 16:38:53 -0600
Message-ID: <CAErSpo6cwcYbi_pFrGrWgMLXH9dx4Po1s5KLDWtc596s+Kv2hQ@mail.gmail.com>
Subject: Re: [ACPI/PCI] possible recursive locking detected
To: Yinghai Lu <yinghai@kernel.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 8:11 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sat, Sep 22, 2012 at 1:10 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>>
>>> > Please check attached patch that should fix the problem.
>>>
>>> updated more aggressive version. two patches.
>>
>> Yes they work nicely. Thank you very much!
>
> Thanks.
>
> v2 breaks acpi_bind_one.
>
> So we should use attached -v3.
>
> Bjorn, please apply -v3 before Taku's patchset.

I  applied this as the first patch in
pci/taku-acpi-pci-host-bridge-v3.  I also merged that branch to
pci/next.
