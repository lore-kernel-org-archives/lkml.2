Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2FRWao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 18:30:44 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:53903 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab2FRWan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 18:30:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo57H_ZD_-Z8z9vD3c50My4Rejtc9gXXrxGxDtQomYmrSA@mail.gmail.com>
References: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com>
 <CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com> <CAErSpo57H_ZD_-Z8z9vD3c50My4Rejtc9gXXrxGxDtQomYmrSA@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Mon, 18 Jun 2012 18:30:21 -0400
Message-ID: <CAOPLpQeJTfB2UNy3O9FgRCyZb=LyMqd0SOsz7qDM0Ur_sfeNhg@mail.gmail.com>
Subject: Re: SNB PCI root information
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 5:56 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> If ACPI provides a perfectly usable generic way to describe this
> topology and the vendor BIOS doesn't bother to use it, I'm not very
> interested in trying to compensate for that BIOS deficiency by adding
> a bunch of non-portable CPU-specific gunk to Linux.

The problem is that all machines get this wrong.  I've tested varies
models from Dell and HP and none of them have the _PXM entry and the
local_cpus fields are wrong.  If there is a reasonably sane way to
compensate for broken BIOSes it should be considered.  We all know how
good BIOS authors are...
