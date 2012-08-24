Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab2HXOmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:42:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58522 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612Ab2HXOmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:42:16 -0400
Message-ID: <503792BF.1030601@gmail.com>
Date: Fri, 24 Aug 2012 22:42:07 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Unable to mount NFSROOT: pcie change breaks e1000?
References: <20120823004604.GA2882@localhost> <503587F4.3090907@huawei.com> <50364641.8010000@gmail.com> <CAErSpo6MepO=Ms+WBqfJmcGH0oZBJbnuYNuswavcF+mdqs2uZw@mail.gmail.com>
In-Reply-To: <CAErSpo6MepO=Ms+WBqfJmcGH0oZBJbnuYNuswavcF+mdqs2uZw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 12:12 AM, Bjorn Helgaas wrote:
> On Thu, Aug 23, 2012 at 9:03 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> Hi Bjorn,
>>         Could you please help to fold this small patch into
>> "[5/40] PCI/core: Use PCI Express Capability accessors"?
>> It fixes a bug reported by Fengguang.
> 
> Thanks, I folded it in.  I looked briefly at whether a similar fix is
> needed in pci_restore_pcie_state().  I don't *think* so, but it
> wouldn't hurt for you to also double-check and let me know if it does.

I think it's optional to add a "pci_is_pcie()" check for pci_restore_pcie_state().
pci_find_saved_cap(dev, PCI_CAP_ID_EXP) should return NULL for non-PCIe device.

--Gerry

