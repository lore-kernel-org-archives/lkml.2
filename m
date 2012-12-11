Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2LKRDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:03:19 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36173 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab2LKRDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:03:18 -0500
Date: Tue, 11 Dec 2012 18:03:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Takashi Iwai <tiwai@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x50
 [snd_hda_intel] returns -11
Message-ID: <20121211170315.GC28827@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Takashi Iwai <tiwai@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I've got the message tagged "HERE" in dmesg running 3.7 (of course, this
is a new message):

...
[   27.444441] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input14
[   29.550494] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x50 [snd_hda_intel] returns -11	<-- HERE
[   29.610630] powernow-k8: this CPU is not supported anymore, using acpi-cpufreq instead.
[   29.676307] acpi-cpufreq: overriding BIOS provided _PSD data
[   32.575161] Program wdm tried to access /dev/mem between 100000->104000.
[   34.242866] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x50 [snd_hda_intel] returns -11	<-- HERE
[ 1502.142636] usbcore: registered new interface driver usblp
[ 1988.970449] Program wdm tried to access /dev/mem between 100000->104000.
[ 1988.994976] pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x50 [snd_hda_intel] returns -11	<-- HERE

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
