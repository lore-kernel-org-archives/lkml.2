Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab2EAA2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:28:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37148 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab2EAA2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:28:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4sYW9juTsJbuow7OzQH3Q-7tuQT1OdnVvGD-b5Gtfb1Q@mail.gmail.com>
References: <1332135624-13528-1-git-send-email-yinghai@kernel.org>
	<CAErSpo4sYW9juTsJbuow7OzQH3Q-7tuQT1OdnVvGD-b5Gtfb1Q@mail.gmail.com>
Date: Mon, 30 Apr 2012 17:28:36 -0700
X-Google-Sender-Auth: 2Lt2YX8fg-zU4BZZtE_S_3EtTz0
Message-ID: <CAE9FiQVrq8dsFADs7JRuousV7Ckc9DnS95iTKp_-UEJA1j8CFA@mail.gmail.com>
Subject: Re: [PATCH -v3 00/11] PCI: pci_host_bridge related cleanup
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 3:59 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sun, Mar 18, 2012 at 11:40 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> will add struct device dev into host_bridge struct.
>> also will add release support to make sure allocated resource get
>> freed during root bus removal including hostbridge and pci_sysdata.
>>
>> The patches need to apply to linus v3.3 plus pci/linux-next
>>
>> could get from
>>        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-hostbridge-cleanup
>
> I applied the patches from this branch to my "next" branch, with the
> exception of the following.  Please take a look and make sure my
> "next" branch has what you expect.

Yes, these 11 patches are correct in your -next tree.

Thanks for updating subject and changelog.

>
>>  x86, PCI: Merge root info printing for not using _CRS path
>
> This changes from printing info for all HT links to just one (probably
> unintentional).  It should also use the "[bus %02x-%02x]" format as we
> do elsewhere.
>
>> x86, PCI: Add print all root info for not using _CRS path
>
> This fixes the unintentional "only print one HT link info" change from above.
>
>> x86, PCI: Allocate temp range array in amd_bus pci_root_info probing
>
> This had no changelog, so I don't know why we want this.

let drop those three patches now. only for printing out etc.

Thanks

Yinghai
