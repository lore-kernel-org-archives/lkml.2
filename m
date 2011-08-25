Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1HYGlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 02:41:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37888 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab1HYGld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 02:41:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4091J2pGvzZKPbKK68LWWkDyVApA7suZYn7miq=tXrQg@mail.gmail.com>
References: <1314167063-15785-1-git-send-email-dengcheng.zhu@gmail.com>
	<1314167063-15785-2-git-send-email-dengcheng.zhu@gmail.com>
	<CAErSpo4091J2pGvzZKPbKK68LWWkDyVApA7suZYn7miq=tXrQg@mail.gmail.com>
Date: Thu, 25 Aug 2011 14:41:32 +0800
Message-ID: <CAOfQC98Nkr7Ek3uQfiD3OdW=YC76XGjfQ4WSfoLpsm2kvqKnog@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] MIPS: PCI: Use pci_bus_remove_resources()/pci_bus_add_resource()
 to set up root resources
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: jbarnes@virtuousgeek.org, ralf@linux-mips.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, eyal@mips.com,
        zenon@mips.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/24 Bjorn Helgaas <bhelgaas@google.com>:
> Wouldn't it be enough to have [PATCH 2/3], which adds the
> pci_create_bus() argument with nobody using it yet, then [PATCH 3/3],
> which makes mips supply the new argument, and add a hunk to [PATCH
> 3/3] that completely removes the bus->resource fixups in
> pcibios_fixup_bus() at the same time?
>
> Bjorn
>

Do you mean to merge this patch to [PATCH 3/3]? OK, that's good!


Deng-Cheng
