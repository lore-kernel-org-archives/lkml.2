Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2CSVhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:37:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37985 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab2CSVhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:37:23 -0400
MIME-Version: 1.0
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 19 Mar 2012 15:37:01 -0600
Message-ID: <CAErSpo5JXodrxMAnMsEXyM0fc4JcSh+W=5YqC0SRzAqRDO8uuQ@mail.gmail.com>
Subject: Re: [PATCH 00/47] PCI, x86: pci root bus hotplug support
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 11:45 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> will add pci_stop_and_remove_bus() to support remove bus in
> /sys/devices/pci.../pci_bus/...
>
> To rescan root, need to
> echo 1 > /sys/bus/pci/rescan_root
>
> It supports acpi path root bus and legacy root bus.

I tried to start discussions about some interesting issues such as
acpi_pci_root_rescan() and /sys/bus/pci/rescan_root.

I don't think it's a good use of my time to re-review all these
patches until after we make some progress on those conversations.

Bjorn
