Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab2CTRUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 13:20:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34236 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab2CTRUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 13:20:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5JXodrxMAnMsEXyM0fc4JcSh+W=5YqC0SRzAqRDO8uuQ@mail.gmail.com>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
	<CAErSpo5JXodrxMAnMsEXyM0fc4JcSh+W=5YqC0SRzAqRDO8uuQ@mail.gmail.com>
Date: Tue, 20 Mar 2012 10:20:32 -0700
X-Google-Sender-Auth: bvqAhAGSIgR6Zqc8g8ZkN7mOAAo
Message-ID: <CAE9FiQVmwRFP+KM6rCSEia+FvayxHP-VL_9sVX5r9AgDzGRGuQ@mail.gmail.com>
Subject: Re: [PATCH 00/47] PCI, x86: pci root bus hotplug support
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 2:37 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sun, Mar 18, 2012 at 11:45 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> will add pci_stop_and_remove_bus() to support remove bus in
>> /sys/devices/pci.../pci_bus/...
>>
>> To rescan root, need to
>> echo 1 > /sys/bus/pci/rescan_root
>>
>> It supports acpi path root bus and legacy root bus.
>
> I tried to start discussions about some interesting issues such as
> acpi_pci_root_rescan() and /sys/bus/pci/rescan_root.
>
> I don't think it's a good use of my time to re-review all these
> patches until after we make some progress on those conversations.

Actually I reordered that patch applying sequence.

 PCI, ACPI: Add acpi_pci_root_rescan()
 x86, PCI: Add arch version pci_root_rescan()
 PCI: Add /sys/bus/pci/rescan_root

will be applied at last. So Jesse could skip those 3 or so patches,
and upstream will only support really physical root-bus hotplug that
user need to press attention button.

     Yinghai
