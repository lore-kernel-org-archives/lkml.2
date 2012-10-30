Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab2J3CCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:02:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55899 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2J3CCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:02:06 -0400
MIME-Version: 1.0
In-Reply-To: <200901071430.55580.jbarnes@virtuousgeek.org>
References: <200901071430.55580.jbarnes@virtuousgeek.org>
Date: Mon, 29 Oct 2012 19:02:05 -0700
X-Google-Sender-Auth: f7WMYVGFQPXLwerucq9jM_eZ3wo
Message-ID: <CAE9FiQVYZUQULpDkGJFr85o5oZTdYYegdXoQCg6V8xY9S6G2pA@mail.gmail.com>
Subject: Re: [git pull] PCI pull request for 2.6.29
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 2:30 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Arjan van de Ven (1):
>       resource: allow MMIO exclusivity for device drivers
>

hi, all

commit e8de1481fd7126ee9e93d6889da6f00c05e1e019
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Wed Oct 22 19:55:31 2008 -0700

    resource: allow MMIO exclusivity for device drivers

only user is e1000e driver. and real fix

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4a7703582836f55a1cbad0e2c1c6ebbee3f9b3a7

is already in the upsteam for https://bugzilla.redhat.com/show_bug.cgi?id=459202

so wonder if e8de1481fd7126ee9e93d6889da6f00c05e1e019 should be
reverted from upstream?

Thanks

Yinghai
