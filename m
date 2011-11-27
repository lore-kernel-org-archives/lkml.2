Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1K0BsD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 20:48:03 -0500
Received: from zaphod.wh17.tu-dresden.de ([141.76.124.10]:55988 "EHLO
	zaphod.wh17.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab1K0BsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 20:48:01 -0500
X-Greylist: delayed 1431 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Nov 2011 20:48:00 EST
X-Spam-DCC: URT: zaphod 1060; Body=1 Fuz1=1 Fuz2=1
Date: Sun, 27 Nov 2011 02:23:46 +0100
From: Henning Schild <henning@wh9.tu-dresden.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tom Gundersen <teg@jklm.no>, ibm-acpi-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Natanji <natanji@gmail.com>, maciej.rutecki@gmail.com, lenb@kernel.org
Subject: Re: [ibm-acpi-devel] Regression in thinkpad-acpi events
Message-ID: <20111127022346.32f11849@schlepp.lan>
In-Reply-To: <20111115230305.GA23325@khazad-dum.debian.net>
References: <4EBAC3B5.5060405@gmail.com>
 <201111142031.06663.maciej.rutecki@gmail.com>
 <4EC16F8E.7060601@gmail.com>
 <201111142118.47256.maciej.rutecki@gmail.com>
 <CAG-2HqVnsmSyHVCvEVf+sZw5NxhR8qSDDB0AtR+igwCCFiwfgQ@mail.gmail.com>
 <20111115230305.GA23325@khazad-dum.debian.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I came across this problem after updating the kernel on my laptop. The
hotkeys actually work until after the first wakeup from hibernation. I
tried 3.0.9 3.1.1 3.1.2 and for hibernation i used tuxonice. It is not
only the acpi events that stop working, also the events that should be
delivered as input events. Reloading the module does not help. Having
the module not loaded for the hibernation also does not help. After
waking up the events will be gone.

Do the Arch kernels use tuxonice? Do you receive events before the
first hibernation?

Henning
