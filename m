Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1EDHHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 03:07:10 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:47371 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753073Ab1EDHHI (ORCPT
	<rfc822;groupwise-jlee@novell.com:6:1>);
	Wed, 4 May 2011 03:07:08 -0400
Message-Id: <4DC187B7020000230002C237@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Wed, 04 May 2011 01:07:03 -0600
From: "Joey Lee" <jlee@novell.com>
To: <tiwai@suse.de>
Cc: <chris@chris-wilson.co.uk>, <melchior.franz@gmail.com>,
        <dri-devel@lists.freedesktop.org>, <carlos@strangeworlds.co.uk>,
        <jlee@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: i915/kms/backlight-combo mode problem (was: Re: Linux
 2.6.39-rc5)
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com>
 <201104301032.05271@rk-nord.at> <s5hiptwavar.wl%tiwai@suse.de>
 <201104301334.53928@rk-nord.at> <s5hiptttick.wl%tiwai@suse.de>
In-Reply-To: <s5hiptttick.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Melchior, 

於 一，2011-05-02 於 14:08 +0200，Takashi Iwai 提到：
> At Sat, 30 Apr 2011 13:34:51 +0200,
> Melchior FRANZ wrote:
> > 
> > Dropping Linus from the CC.
> > 
> > 
> > * Takashi Iwai -- Saturday 30 April 2011:
> > * * At Sat, 30 Apr 2011 10:32:04 +0200, Melchior FRANZ wrote:
> > > > Yes, backlight adjustment generally works on this notebook, but only
> > > > with "acpi_osi=Linux" on the command line.
> > > 
> > > acpi_osi quirk should be better added statically, then.
> > 
> > No, I guess the problem here is that acer_wmi doesn't support this
> > machine yet. I told the ACER WMI maintainer and sent a DSDT image,
> > but this message was thoroughly ignored.
> > 
> > 
> >   $ dmesg|grep -i acer
> >   [    0.000000] DMI: Acer TM5735/BA51_MV, BIOS V1.04 09/23/2010
> >   [   71.850534] acer_wmi: Acer Laptop ACPI-WMI Extras
> >   [   72.350278] acer_wmi: Unable to detect available WMID devices
> >   
> >   Machine: Acer Travelmate 5735Z-452G32Mnss
> 
> Hm, but the backlight control is done via the standard ACPI, no?
> If so, the fact that acer_wmi doesn't work sounds irrelevant.
> 
> BTW, did you try my previous patch?
> 
> 
> Takashi

Yes, please try Takashi's previous patch. 

I am tracing bko#34142, but this issue does not related to your
backlight control, because there have _BCM, _BQC declare in your DSDT,
your machine MUST SUPPORTED by standard acpi backlight interface.

Even the acer-wmi can probed on your machine, it cann't help anything
for your backlight control.


Thank's a lot!
Joey Lee

