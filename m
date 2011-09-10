Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab1IJC4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 22:56:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757267Ab1IJC4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 22:56:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAAJw_ZvTX374XDZEi_rFAL=797au_7J9gfuDVz-h9o-+Zp_f4w@mail.gmail.com>
References: <CAAJw_Zv9LaOut6+aQWki_-nCngEEfh-OVqF4rsUwb-LPfLk8Ug@mail.gmail.com>
 <CAAJw_ZvP6m=3T0YoYq6VJdOKMxzm3fDcdJoDY8wqqDV8GZB+Dg@mail.gmail.com>
 <1315290313.2565.0.camel@edumazet-laptop> <CAAJw_ZvTX374XDZEi_rFAL=797au_7J9gfuDVz-h9o-+Zp_f4w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Sep 2011 19:55:38 -0700
Message-ID: <CA+55aFyGQuPh0W7aEtng1NM1q3Vg6HAT83eiNk+fRFUjpsXPCg@mail.gmail.com>
Subject: Re: linux-3.1-0-rc4 bus error ... MPS configured higher than maximum
 supported by the device. If a bus issue occurs, try running with pci=pcie_bus_safe.
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        Jordan_Hargrave@dell.com, Jon Mason <mason@myri.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 1:39 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
> Thanks. I saw that. And the system nearly got trashed even though I've
> no hpsa. Grub went into rescue mode after reboot, and I had to rebuild
> the grub boot sector.
>
> Now, it's all ok with pcie_aspm=force and pci=pcie_bus_safe.

Jeff, Eric,
  Is the current -git state ok for you guys? I just pushed out commit
ed2888e906b5 ("PCI: Remove MRRS modification from MPS setting code")
which should default to safe pcie behavior.

I just wanted to verify that that was all sufficient for this thread..

                      Linus
