Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab2ISQ5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:57:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53632 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab2ISQ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:57:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120917113423.GA28759@kroah.com>
References: <1347880974-13615-1-git-send-email-thierry.reding@avionic-design.de>
 <20120917113423.GA28759@kroah.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 19 Sep 2012 10:57:15 -0600
Message-ID: <CAErSpo4q7KYn3bvNQ0wAXV=+PRAFH_c=MgOLOTDKgaNCjE_aXg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] PCI: Keep pci_fixup_irqs() around after init
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Chris Zankel <chris@zankel.net>, Greg Ungerer <gerg@uclinux.org>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 5:34 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Sep 17, 2012 at 01:22:53PM +0200, Thierry Reding wrote:
>> Remove the __init annotations in order to keep pci_fixup_irqs() around
>> after init (e.g. for hotplug). This requires the same change for the
>> implementation of pcibios_update_irq() on all architectures. While at
>> it, all __devinit annotations are removed as well, since they will be
>> useless now that HOTPLUG is always on.
>>
>> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>> ---
>> Changes in v2:
>> - remove __init and __devinit annotations altogether
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I applied these (both 1/2 and 2/2) to my "next" branch.  Thanks!

Bjorn
