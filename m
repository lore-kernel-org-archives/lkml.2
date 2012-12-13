Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab2LMWBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:01:43 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:32779 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824Ab2LMWBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:01:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Amos Kong <kongjianjun@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] PCI Hotplug: workaround for Thunderbolt on Intel DZ77RE-75K motherboard
Date: Thu, 13 Dec 2012 23:06:42 +0100
Message-ID: <1934147.CrrSRCENPm@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121213204953.GA25085@otc-wbsnb-06>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com> <CA+55aFwxmhcgORCnDKwcp5EuzvC0iz02O4QR3H_stTXDbprYSA@mail.gmail.com> <20121213204953.GA25085@otc-wbsnb-06>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 13, 2012 10:49:53 PM Kirill A. Shutemov wrote:
> On Thu, Dec 13, 2012 at 12:30:04PM -0800, Linus Torvalds wrote:
> > On Thu, Dec 13, 2012 at 12:25 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > >
> > > Linus will not be happy with those kind of delay.
> > 
> > Indeed. And the DMI check is bogus too, since the "there can be
> > delays" is apparently part of the pcie hotplug spec.
> 
> It's ACPI PCI hotplug, not PCIe native hotplug. PCIe hotplug spec is not
> relevant.
> 
> IIUC, in ACPI case devices should be ready to be enumerated, before you
> get notification. Rafael, is it correct?

Not necessarily.  The ACPI nodes will be, the device themselves are still PCI
devices. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
