Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab2HXSxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:53:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54325 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2HXSw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:52:58 -0400
MIME-Version: 1.0
In-Reply-To: <50325732.3000700@gmail.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
 <CAErSpo7WoEeWayMQ__H4jiKKmMdNgyLMYdRmJ0Nf0LoEKjFRmA@mail.gmail.com> <50325732.3000700@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 24 Aug 2012 12:52:37 -0600
Message-ID: <CAErSpo5TP4j9bqL+GvkxSNKtyzDOh6m5agRaS0_=tAb+46Cvow@mail.gmail.com>
Subject: Re: [PATCH v3 00/32] provide interfaces to access PCIe capabilities registers
To: Jiang Liu <liuj97@gmail.com>
Cc: Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 9:26 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Hi Bjorn,
>         I have made following changes according to your suggestions,
>         1) get rid of the "pci_" prefix for access functions.
>         2) rename pci_pcie_capability_change_{word|dword}() to
>         pcie_capability_clear_and_set_{word|dword}.
>         3) add pcie_capability_{set|clear}_{word|dword}().
>         4) Add "Acked-by" and "Reviewed-by"
>         5) rebase to your latest pci-next tree
>
>         So could you please help to pull from "https://github.com/jiangliu/linux.git topic/pcie-cap"
> or should I send all the patches to mail list again?

I applied these (with the fixups mentioned in this thread) to my
"next" branch.  Unfortunately, I just missed the 0824 -next tree, and
Stephen is taking a hiatus for KS/LPC next week, so it might be a
while before they show up in his tree.

Thanks a lot for doing this work!  I feel much more confident that we
can avoid driver issues with the v1/v2 differences, and you removed an
appreciable amount of code at the same time:

 52 files changed, 591 insertions(+), 823 deletions(-)
