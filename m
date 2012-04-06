Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab2DFQBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 12:01:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64880 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab2DFQBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 12:01:39 -0400
MIME-Version: 1.0
In-Reply-To: <4F7F10C5.1050901@gmail.com>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
	<1332135996-13860-41-git-send-email-yinghai@kernel.org>
	<4F7F10C5.1050901@gmail.com>
Date: Fri, 6 Apr 2012 09:01:39 -0700
Message-ID: <CAE9FiQUEJ4Jvz0BHJ8LCBNpXWB3Cf6u3k9F1avAd4a-fkGOB=Q@mail.gmail.com>
Subject: Re: [PATCH -v3 40/47] PCI: Add pci bus removal through /sys/.../pci_bus/.../remove
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 8:50 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Hi Yinghai,
>        I found many other drivers assume that a pci bus won't disappear if
> the corresponding PCI bridge device still exists. The sysfs interface proposed
> here breaks that assumption and may cause many access-after-free issues.
> So what's the purpose of this interface? Should we remove this interface or
> enhance other drivers to avoid invalid memory access issues?

ok, will make it only show up on root bus.

Yinghai
