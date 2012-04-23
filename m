Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2DWMDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:03:04 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54001 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2DWMDC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:03:02 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUWVwUr19xL0Dn5mHnZjQaVjj6VYD3BMMktEWO0vgoZEXw@mail.gmail.com>
References: <CA+icZUWVwUr19xL0Dn5mHnZjQaVjj6VYD3BMMktEWO0vgoZEXw@mail.gmail.com>
Date: Mon, 23 Apr 2012 14:03:01 +0200
Message-ID: <CA+icZUUGFaz0c-tHa9EGUxZaxPj_M=zrE+kE0dv5UMoA6GyN3w@mail.gmail.com>
Subject: Re: Warning: pnp 00:0b: can't evaluate _CRS: 12311
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: linux-acpi@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, Adam Belay <abelay@mit.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 11:48 AM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> [ Please CC me I am not subscribed to this ML ]
>
> Hi,
>
> with a self-compiled linux-3.4-rc4 I am seeing this bugs/failures/warnings:
>
> [    0.241572] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
>
> [    0.279385]  pci0000:00: ACPI _OSC request failed (AE_ERROR),
> returned control mask: 0x1d
>
> [    0.293699] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.294032] ACPI Error: Invalid/unsupported resource descriptor:
> Type 0x00 (20120320/utresrc-650)
> [    0.294037] pnp 00:0b: can't evaluate _CRS: 12311
>
> The same outputs I have seen also with an unsupported drm-intel-next
> kernel from Ubuntu/PPA archives [1].
>
> What does ist mean? Is it harmless? Buggy firmware/bios?
>
> Do you need more background infos (dmesg, kernel-config, etc.)?
>
> Regards,
> - Sedat -
>
> [1] http://kernel.ubuntu.com/~kernel-ppa/mainline/drm-intel-next/current/

I have upgraded this Samsung series-5 notebook from BIOS version 05XK
to 06XK, but the pnp/_CRS warning still remains.

- Sedat -
