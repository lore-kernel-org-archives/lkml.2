Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab2ASPyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:54:23 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60375 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab2ASPyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:54:21 -0500
MIME-Version: 1.0
In-Reply-To: <4F17D7B7.3010609@jp.fujitsu.com>
References: <1324083165-805-1-git-send-email-yinghai@kernel.org>
	<4F17D7B7.3010609@jp.fujitsu.com>
Date: Thu, 19 Jan 2012 07:54:20 -0800
X-Google-Sender-Auth: QFPpTJFlKrTPwZpqs7y_NjaBcSg
Message-ID: <CAE9FiQW0nGvNO1-fHH_1Tjn67obQqXw=6Rydq=2VU91jo0FY=A@mail.gmail.com>
Subject: Re: [PATCH -v2] pciehp: Checking pci conf reading to new added device
 instead of sleep 1s
From: Yinghai Lu <yinghai@kernel.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/19 Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> (2011/12/17 9:52), Yinghai Lu wrote:
>
> <snip.>
>>
>> -/*
>> - * Read the config data for a PCI device, sanity-check it
>> - * and fill in the dev structure...
>> - */
>> -static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
>> +bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *l,
>> +                              int crs_timeout)
>
> EXPORT_SYMBOL() for pci_bus_read_dev_vendor_id() is needed to build
> pciehp as a kernel module.
>

Thanks for reviewing.

Will update the patch accordingly and separate it to two at least.

Yinghai
