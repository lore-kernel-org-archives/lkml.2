Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2B0XPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:15:43 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62126 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab2B0XPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:15:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.180.97.196 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <20120227113129.c03c34ff7ea516f155cf0c87@canb.auug.org.au>
References: <20120227113129.c03c34ff7ea516f155cf0c87@canb.auug.org.au>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 27 Feb 2012 16:15:20 -0700
Message-ID: <CAErSpo4r81nYtUNQ8_Wt1RGsCrWFJ4PAGSnRdpKV6vRNhkS9Lg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the pci tree with the mips tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 5:31 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Jesse,
>
> Today's linux-next merge of the pci tree got a conflict in
> arch/mips/pci/pci.c between commit f79eaeb10849 ("MIPS: PCI: use
> list_for_each_entry() for bus->devices traversal") from the mips tree and
> commit 96a6b9ad05a2 ("mips/PCI: get rid of device resource fixups") from
> the pci tree.
>
> The latter appears to supersede the former, so I used that.

Sounds right to me.  Thanks.

Bjorn
