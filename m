Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab0E3Whf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 18:37:35 -0400
Received: from science.horizon.com ([71.41.210.146]:50304 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754523Ab0E3Whe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 18:37:34 -0400
Date: 30 May 2010 18:37:28 -0400
Message-ID: <20100530223728.14700.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: sameo@linux.intel.com
Subject: Re: [GIT] [2.6.35] MFD pull request
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus wrote:
> Samuel - this adds the CONFIG_MFD thing, with absolutely _no_ explanation. 
> So now people see this totally incomprehensible question:
>
>	Enable Multifunction device drivers? (Y/n)
>
> with no sane way to decide whether they should actually enable it or not.  

Seconded.  This actually happens a lot; I don't mean to pick on the MFD drivers
especially.  Sometimes the best way to answer a new config question is to
RTFS, which is a bit tedious.

For example, the "ACPI 4.0 Power Meter" (CONFIG_ACPI_POWER_METER).  To me,
a power meter is a large glass-encased object containing a spinning
aluminum disc and mounted on the wall of my house which determines my
monthly power bill.

How this relates to ACPI 4.0 firmware is unclear.  Indeed, how do I figure
out of I have ACPI 4.0 firmware?

Then there's CONFIG_SFI.  Nowhere in the Kconfig text does it explain that
it's intended as a lightweight alternative to ACPI for hand-held devices
and not for desktop machines.

Then there are the PCI_GO* options... I still have no idea.  (I just pick
"any", figuring it's the most likely to work.)

I think the CONFIG_PCI help text could use some updating.

The CONFIG_PCIEPORTBUS is unnecessarily confusing.  It doesn't clearly
explain, if I have PCI express slots on my computer:
- Do I actually need this to boot?
- Does it do anything besides enable a config submenu?

CONFIG_MCA (admittedly a critically endangered interest group, but
still listed as "Maintained" in MAINTAINERS) stresses the importance
of the web site address given in in Documentation/mca.txt, which is
http://www.dgmicro.com/mca/.  That domain no longer exists (expired March
'07) and has been grabbed by a squatter.  It can be found on the wayback
machine at
http://web.archive.org/web/20070225223240/http://www.dgmicro.com/mca/
and gives a last update date of 1999.

It would be easy to go on...
