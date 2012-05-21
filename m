Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2EUUGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:06:47 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59529 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2EUUGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:06:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX-Ut3=WfjeKVBBO55NMQTXZdCC2NbsrX=p3MHVWLahtQ@mail.gmail.com>
References: <1336422606-4244-1-git-send-email-yinghai@kernel.org>
 <CAErSpo6OZYXz-M=C9r154MY7kwC7LRR3ZnQe3pnmVJY2uoWeRw@mail.gmail.com>
 <CAE9FiQXN5z0riswyECKw5OKe+nPUBN2yZ1d4=Asb3kqaj770NA@mail.gmail.com>
 <CAErSpo71805jTs1qVMx+9ghzUub77r47VqpXF0sVOFuDSq6pmg@mail.gmail.com> <CAE9FiQX-Ut3=WfjeKVBBO55NMQTXZdCC2NbsrX=p3MHVWLahtQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 21 May 2012 14:06:23 -0600
Message-ID: <CAErSpo4zxo+A-uLNCGj1Fe25t2TD+0cjgpdncV9kykTe0pd0CQ@mail.gmail.com>
Subject: Re: [PATCH 00/21] PCI: use busn_res to replace bus secondary/subordinate
To: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 10:38 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, May 18, 2012 at 4:32 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:

> looks one of commit author is messed up.
>
> http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=commitdiff;h=b20238f05059818de8edd76cb5523b6bf8e26527
>
> author  Bjorn Helgaas <bhelgaas@google.com>
>        Fri, 18 May 2012 17:35:50 +0000 (11:35 -0600)
> committer       Bjorn Helgaas <bhelgaas@google.com>
>        Fri, 18 May 2012 20:00:35 +0000 (14:00 -0600)
> Will use them insert/update busn res in pci_bus struct.
>
> [bhelgaas: print conflicting entry if insertion fails]
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>
> but if changing it would take you too much time, just leave it as is.

Oops, sorry, I squashed two patches into one (no point in two patches
that (1) add A and (2) clean up A), and I must have screwed up the
author then.  I fixed it in my tree.

I also changed the branch name to "for-3.6" to make it more obvious
that the changes there are targeted for the 3.6 merge window, not for
3.5.  After Linus pulls my current "next" branch into 3.5-rcX, I'll
move the for-3.6 stuff to the "next" branch as usual.

>> Let me know what series you'd like me to work on next, and send the
>> current patches to the list.
>
> Maybe for-pci-res-alloc could be moved forwarded, then
> for-pci-busn-alloc
> for-pci-root-bus-hotplug
> for-pci-for-each-res-addon

OK, just send your current patches to the list so everybody has a
chance to see them.

Bjorn
