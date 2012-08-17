Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab2HQOfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:35:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59951 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756066Ab2HQOfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:35:04 -0400
Date: Fri, 17 Aug 2012 16:34:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pekka Enberg <penberg@kernel.org>, ibm-acpi-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Subject: Re: [PROBLEM] thinkpad_acpi: unhandled HKEY event 0x6040
Message-ID: <20120817143459.GB3462@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Pekka Enberg <penberg@kernel.org>,
	ibm-acpi-devel@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>,
	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
	Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org
References: <CAOJsxLEb+J=p8Kd782VWPm0ft3D9ujOnV0x_Av+fjWp6QiTHQQ@mail.gmail.com>
 <20120817141748.GA12934@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120817141748.GA12934@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 11:17:48AM -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 17 Aug 2012, Pekka Enberg wrote:
> > [ 3129.616297] thinkpad_acpi: unhandled HKEY event 0x6040
> > [ 3129.616298] thinkpad_acpi: please report the conditions when this
> > event happened to ibm-acpi-devel@lists.sourceforge.net
> > [ 3129.616949] thinkpad_acpi: undocked from hotplug port replicator
> > [ 3129.617065] ACPI: \_SB_.GDCK - undocking
> > [ 3144.184916] ACPI: \_SB_.GDCK - docking
> > [ 3144.185204] ACPI: Unable to dock!
> > 
> > and the monitor doesn't come up.
> 
> The monitor doesn't come up because of something else, check the GPU drivers
> and userspace.  And also why the docking failed...

Btw, I'm getting a similar thing when I unplug my x121e from AC:

[  613.517178] thinkpad_acpi: unknown possible thermal alarm or keyboard event received
[  613.533949] thinkpad_acpi: temperatures (Celsius): 60 0 60 0 0 0 32 0
[  613.536880] thinkpad_acpi: unhandled HKEY event 0x6040
[  613.539703] thinkpad_acpi: please report the conditions when this event happened to ibm-acpi-devel@lists.sourceforge.net

this is when I plug it back:

[  623.308867] thinkpad_acpi: unknown possible thermal alarm or keyboard event received
[  623.322868] thinkpad_acpi: temperatures (Celsius): 60 0 60 0 0 0 32 0
[  623.322926] thinkpad_acpi: unhandled HKEY event 0x6040
[  623.322938] thinkpad_acpi: please report the conditions when this event happened to ibm-acpi-devel@lists.sourceforge.net

All with 3.6-rc2 + tip/master.

Thanks.

-- 
Regards/Gruss,
Boris.
