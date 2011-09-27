Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1I0R7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:59:55 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60379 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab1I0R7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:59:54 -0400
MIME-Version: 1.0
In-Reply-To: <4E82017C.3010304@redhat.com>
References: <4E82017C.3010304@redhat.com>
Date: Tue, 27 Sep 2011 12:59:50 -0500
Message-ID: <CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
Subject: Re: [REGRESSION] e1000e failure triggered by "PCI: Remove MRRS
 modification from MPS setting code"
From: Jon Mason <mason@myri.com>
To: Avi Kivity <avi@redhat.com>
Cc: Sven Schnelle <svens@stackframe.org>, Simon Kirby <sim@hostway.ca>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 12:01 PM, Avi Kivity <avi@redhat.com> wrote:
> Commit ed2888e906b567 (merged 3.1-rc6) causes a reproducible failure with my
> e1000e card here.  Starting a kvm guest (which mostly consists of shoving
> display updates over X over ssh, as far as the network is concerned) locks
> up the card hard.
>
> The failure is easily reproducible, will gladly test patches.

Does the problem occur with the adapter assigned to the kvm guest or
the host?  I assume that you are running with the default behavior and
not with the boot arg "pci=pcie_bus_perf".  Can you get the dmesg
output (specifically the lines that have "Dev MPS") and lspci -vvv on
the host?  Is this an e1000e 4port adapter?

Thanks,
Jon

>
> --
> error compiling committee.c: too many arguments to function
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
