Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459Ab2AMXOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:14:44 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59689 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab2AMXOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:14:43 -0500
MIME-Version: 1.0
In-Reply-To: <20120113212409.GA27671@srcf.ucam.org>
References: <20120111103408.30cfa338@jbarnes-desktop> <CA+55aFwDVEH1NwEgKCQSv9ee3P2ma1aqtjOo-s2BeURyeTGo8g@mail.gmail.com>
 <20120113212409.GA27671@srcf.ucam.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jan 2012 15:14:21 -0800
X-Google-Sender-Auth: HKqrHWCqu8CBGonbAWc8HgbtuDA
Message-ID: <CA+55aFwJvvrNyqNStjM9iYcRa+t4FuuJW48SixXN+6H6sJ9e8w@mail.gmail.com>
Subject: Re: [git pull] PCI changes
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 1:24 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>>
>> So why is acpi_pci_root_add() special? Cna you explain that part to me?
>
> pcie_no_aspm() means "Do not permit ASPM to be enabled" - it doesn't
> alter the existing state. pcie_clear_aspm() does that.

I *know*.

So look again.

Why is acpi_pci_root_add() special?

Because dammit, it does exactly that pcie_clear_aspm() for the
ACPI_FADT_NO_ASPM case.

That was my question.  Why does it do that, when the commit log (and
the other users) say that ACPI_FADT_NO_ASPM means "don't touch".

It touches.

               Linus
