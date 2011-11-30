Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab1K3JWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 04:22:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64295 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab1K3JWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 04:22:38 -0500
Message-ID: <4ED5F5D7.8020208@gmail.com>
Date: Wed, 30 Nov 2011 10:22:31 +0100
From: Natanji <natanji@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Henning Schild <henning@wh9.tu-dresden.de>
CC: Tom Gundersen <teg@jklm.no>, ibm-acpi-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        maciej.rutecki@gmail.com, lenb@kernel.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [ibm-acpi-devel] Regression in thinkpad-acpi events
References: <4EBAC3B5.5060405@gmail.com> <201111142031.06663.maciej.rutecki@gmail.com> <4EC16F8E.7060601@gmail.com> <201111142118.47256.maciej.rutecki@gmail.com> <CAG-2HqVnsmSyHVCvEVf+sZw5NxhR8qSDDB0AtR+igwCCFiwfgQ@mail.gmail.com> <20111115230305.GA23325@khazad-dum.debian.net> <20111127022346.32f11849@schlepp.lan>
In-Reply-To: <20111127022346.32f11849@schlepp.lan>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The standard Arch kernel does not use tuxonice, you need to build your
kernel manually if you want it. I also don't receive these events before
the first hibernation, so you might be having a different problem.

Concerning PROCFS_ACPI, a user posted over at the bug report in the Arch
bugtracker [1] that re-enabling this did not solve this problem. So the
problem probably lies somewhere else still...

[1] https://bugs.archlinux.org/task/26658#comment85971

On Sun 27 Nov 2011 02:23:46 AM CET, Henning Schild wrote:
> I came across this problem after updating the kernel on my laptop. The
> hotkeys actually work until after the first wakeup from hibernation. I
> tried 3.0.9 3.1.1 3.1.2 and for hibernation i used tuxonice. It is not
> only the acpi events that stop working, also the events that should be
> delivered as input events. Reloading the module does not help. Having
> the module not loaded for the hibernation also does not help. After
> waking up the events will be gone.
>
> Do the Arch kernels use tuxonice? Do you receive events before the
> first hibernation?
>
> Henning
