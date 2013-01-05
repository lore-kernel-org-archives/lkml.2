Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3AEAJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 19:09:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60570 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab3AEAJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 19:09:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiang Liu <liuj97@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [Alternative 2][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
Date: Sat, 05 Jan 2013 01:14:52 +0100
Message-ID: <2913597.xNs4ttWDNI@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQVSaC=D-KzSPJaP0=HGRnNgxBYv+S6=PqF_3Li+ihTnEQ@mail.gmail.com>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan> <1832392.tD5dEjQMy4@vostro.rjw.lan> <CAE9FiQVSaC=D-KzSPJaP0=HGRnNgxBYv+S6=PqF_3Li+ihTnEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 04, 2013 04:03:01 PM Yinghai Lu wrote:
> On Fri, Jan 4, 2013 at 3:38 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> --- a/arch/x86/include/asm/pci.h
> >> +++ b/arch/x86/include/asm/pci.h
> >> @@ -14,6 +14,7 @@
> >>  struct pci_sysdata {
> >>       int             domain;         /* PCI domain */
> >>       int             node;           /* NUMA node */
> >> +     void            *acpi_handle;
> >>  #ifdef CONFIG_X86_64
> >>       void            *iommu;         /* IOMMU private data */
> >>  #endif
> >>
> 
> acpi_handle is not good name and it is confusing.

Well, what would be a better name in your opinion?

I was going to put that into a #ifdef CONFIG_ACPI / #endif, so what about
calling it acpi_data?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
