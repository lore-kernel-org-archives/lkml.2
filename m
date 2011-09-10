Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1IJFzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 01:55:43 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62758 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab1IJFzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 01:55:42 -0400
MIME-Version: 1.0
In-Reply-To: <1315630153.2606.24.camel@edumazet-laptop>
References: <CAAJw_Zv9LaOut6+aQWki_-nCngEEfh-OVqF4rsUwb-LPfLk8Ug@mail.gmail.com>
	<CAAJw_ZvP6m=3T0YoYq6VJdOKMxzm3fDcdJoDY8wqqDV8GZB+Dg@mail.gmail.com>
	<1315290313.2565.0.camel@edumazet-laptop>
	<CAAJw_ZvTX374XDZEi_rFAL=797au_7J9gfuDVz-h9o-+Zp_f4w@mail.gmail.com>
	<CA+55aFyGQuPh0W7aEtng1NM1q3Vg6HAT83eiNk+fRFUjpsXPCg@mail.gmail.com>
	<1315630153.2606.24.camel@edumazet-laptop>
Date: Sat, 10 Sep 2011 13:55:42 +0800
Message-ID: <CAAJw_Zt7dWh_=DHOevxmudyS8wzn7dY4NJozwCMW0kpJGcaBSQ@mail.gmail.com>
Subject: Re: linux-3.1-0-rc4 bus error ... MPS configured higher than maximum
 supported by the device. If a bus issue occurs, try running with pci=pcie_bus_safe.
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Jordan_Hargrave@dell.com,
        Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 12:49 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 09 septembre 2011 à 19:55 -0700, Linus Torvalds a écrit :
>> On Tue, Sep 6, 2011 at 1:39 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>> >
>> > Thanks. I saw that. And the system nearly got trashed even though I've
>> > no hpsa. Grub went into rescue mode after reboot, and I had to rebuild
>> > the grub boot sector.
>> >
>> > Now, it's all ok with pcie_aspm=force and pci=pcie_bus_safe.
>>
>> Jeff, Eric,
>>   Is the current -git state ok for you guys? I just pushed out commit
>> ed2888e906b5 ("PCI: Remove MRRS modification from MPS setting code")
>> which should default to safe pcie behavior.
>>
>> I just wanted to verify that that was all sufficient for this thread..
>>
>
> Hi Linus
>
> I pulled your last changes, and did some tests on my HP BL460c G6,
> including several stress sessions (make -j128 and various benches)
>
> So far, everything seems fine, thanks.

Couldn't pulled anything for the past few days. Still stuck at commit
9e79e3e9dd9672b37ac9412e9a926714306551fe.

fatal: Unable to look up git.kernel.org (port 9418) (Name or service not known)
failed


Jeff
