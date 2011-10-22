Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab1JVWIL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 18:08:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab1JVWIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 18:08:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] PCI / ACPI: Make acpiphp ignore root bridges using PCIe native hotplug
Date: Sun, 23 Oct 2011 00:10:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <201110220043.38635.rjw@sisk.pl> <CAE9FiQUxuajrqka97M_tvbXoMSzPTBGyjiBib_EG4MjRTuNmFQ@mail.gmail.com>
In-Reply-To: <CAE9FiQUxuajrqka97M_tvbXoMSzPTBGyjiBib_EG4MjRTuNmFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110230010.37802.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 22, 2011, Yinghai Lu wrote:
> On Fri, Oct 21, 2011 at 3:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > If the kernel has requested control of the PCIe native hotplug
> > feature for a given root complex, the acpiphp driver should not try
> > to handle that root complex and it should leave it to pciehp.
> > Failing to do so causes problems to happen if acpiphp is loaded
> > before pciehp on such systems.
> 
> Should pciehp be built-in kernel instead of as a module?

Well, perhaps.  Still, though, if someone doesn't build pciehp and
the control of the native PCIe hotplug is granted for a given root
complex, acpiphp won't work anyway.

Thanks,
Rafael
