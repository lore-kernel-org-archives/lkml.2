Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2GVVzJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 17:55:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45693 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2GVVzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 17:55:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAH0O0Mx+-QY9Wx4wZpO2vZNViV0UWAEns7AwBXwEh96brCzuug@mail.gmail.com>
References: <CAH0O0Mx+-QY9Wx4wZpO2vZNViV0UWAEns7AwBXwEh96brCzuug@mail.gmail.com>
Date: Sun, 22 Jul 2012 18:55:06 -0300
Message-ID: <CAEF_9UDDhz_n8Rj0Spv5MkyG4cyMLJwxUFpNKi8duJ4JDpMuTQ@mail.gmail.com>
Subject: Re: Kernel not detecting all of physical RAM in 1st generation Apple TV
From: =?ISO-8859-1?Q?Dami=E1n_Gatabria?= <dgatabria@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've hit the same problem; 3.4.4 still only uses 64MB of memory, even
though it detects all 256MB of it. Could anybody please at least
review the kernel config provided by Bharath and let us know if
there's anything obviously wrong with it or if this is expected
behavior for some reason?


Thank you.



On Mon, Jun 25, 2012 at 10:52 PM, Bharath Ramesh <bramesh.dev@gmail.com> wrote:
>
> I am trying to get a minimal kernel config running on a 1st generation
> Apple TV to compile the kernel so that I can have it detect all of the
> 256MB of RAM the device has. A brief summary to get Linux booting on
> the 1st generation Apple TV requires the use of the atv-bootloader
> project [1]. The 1st generation Apple TV uses EFI and the
> atv-bootloader project translates EFI structures to standard PC BIOS
> structures. The issue I am facing is that kernel doesnt always detect
> the entire 256MB of RAM that the Apple TV has. With a very minimal
> change in the kernel config I can cause the kernel not to detect the
> entire 256MB of RAM. I have test config along with the respective
> dmesg output which shows this issue. This was not the case with the
> earlier 2.6.24 kernel that I am running, the 2.6.24 kernel is a Ubuntu
> 8.04 distribution kernel. The following config and dmesg is using
> kernel.org source.
>
> config-3.2.18-nouveau-256M: http://pastebin.com/9V8dSED3
> config-3.2.18-nouveau-64M: http://pastebin.com/CsUK0yy3
> config.3.2.18-nouveau-256M-64M.diff: http://pastebin.com/MkYbQf5V
> dmesg.3.2.18-nouveau-256M: http://pastebin.com/UUYBzqm8
> dmesg.3.2.18-nouveau-64M: http://pastebin.com/FDntUsfd
> dmesg.3.2.18-nouveau-256M-64M.diff: http://pastebin.com/2myAa9Z0
>
> Any help in debugging this issue that I can get the kernel to always
> detect all of the RAM would be greatly appreciated. I am not
> subscribed to the list, would greatly appreciate it if I am copied in
> the response.
>
> Thanks,
>
> Bharath
>
> [1] http://code.google.com/p/atv-bootloader/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
