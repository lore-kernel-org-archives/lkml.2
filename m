Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934807Ab1JaXON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 19:14:13 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60769 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934704Ab1JaXOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 19:14:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAJaTeTq6p_ToKuB3+3XBQV2xgfNtPxKE-E7KkYhuHD-JFABmtA@mail.gmail.com>
References: <20111028214726.20088.30551.stgit@amt.stowe>
	<CAJaTeTq6p_ToKuB3+3XBQV2xgfNtPxKE-E7KkYhuHD-JFABmtA@mail.gmail.com>
Date: Mon, 31 Oct 2011 17:14:09 -0600
Message-ID: <CAL-B5D1fnazcDybUUXdCegX6cJ-eu0_gdGwSkgczn3bDUwG7nw@mail.gmail.com>
Subject: Re: [PATCH -v2 00/16] PCI: Re-factor PCI's 'latency timer' setup
From: Myron Stowe <myron.stowe@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Myron Stowe <myron.stowe@redhat.com>, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org, linux@arm.linux.org.uk, dhowells@redhat.com,
        ysato@users.sourceforge.jp, tony.luck@intel.com, fenghua.yu@intel.com,
        monstr@monstr.eu, ralf@linux-mips.org, benh@kernel.crashing.org,
        paulus@samba.org, lethal@linux-sh.org, davem@davemloft.net,
        cmetcalf@tilera.com, gxt@mprc.pku.edu.cn, tglx@linutronix.de,
        mingo@redhat.com, chris@zankel.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 6:46 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> On Fri, Oct 28, 2011 at 23:47, Myron Stowe wrote:
>>  - * blackfin and h8300 architectures do not seem to support PCI (no
>>   root bus scanning etc. exists within them) but they do have PCI header
>>   files.
>
> correct, all Blackfin parts in current mainline lack any sort of PCI
> support.  the header existence (iirc) is two fold:
>  - a lot of drivers like to use the pci/dma interface to manage memory
> instead of a pure dma interface
>  - BF535 has pci support, but we don't support that, and have largely
> dropped anything related to it
>
> so if this compile passes for Blackfin, it should be fine.  however,
> i'm lazy, so i don't suppose you've got a branch somewhere for me to
> pull to quickly compile test ?

I created a 'pci-latency-v2' branch at git://github.com/myron-stowe/linux.git
that maintainers of the various architectures can use to pull from for a compile
test of this patch series.

Myron

>  if not, simply putting it into a
> branch that gets into linux-next should be sufficient as i think
> Stephen had Blackfin coverage in there ...
> -mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
