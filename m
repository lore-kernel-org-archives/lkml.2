Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab3AEADG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 19:03:06 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:33153 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab3AEADE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 19:03:04 -0500
MIME-Version: 1.0
In-Reply-To: <1832392.tD5dEjQMy4@vostro.rjw.lan>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan>
	<113112384.JZ1gZKlJRa@vostro.rjw.lan>
	<20130104010038.GA11155@google.com>
	<1832392.tD5dEjQMy4@vostro.rjw.lan>
Date: Fri, 4 Jan 2013 16:03:01 -0800
X-Google-Sender-Auth: -FuZHVPiLmPzc1nV4HJgy0v-GvM
Message-ID: <CAE9FiQVSaC=D-KzSPJaP0=HGRnNgxBYv+S6=PqF_3Li+ihTnEQ@mail.gmail.com>
Subject: Re: [Alternative 2][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiang Liu <liuj97@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 3:38 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> --- a/arch/x86/include/asm/pci.h
>> +++ b/arch/x86/include/asm/pci.h
>> @@ -14,6 +14,7 @@
>>  struct pci_sysdata {
>>       int             domain;         /* PCI domain */
>>       int             node;           /* NUMA node */
>> +     void            *acpi_handle;
>>  #ifdef CONFIG_X86_64
>>       void            *iommu;         /* IOMMU private data */
>>  #endif
>>

acpi_handle is not good name and it is confusing.
