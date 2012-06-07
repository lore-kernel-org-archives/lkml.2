Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab2FGVBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 17:01:41 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:35030 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab2FGVBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 17:01:40 -0400
MIME-Version: 1.0
Reply-To: rus@sfinxsoft.com
In-Reply-To: <20120607151352.GA8261@x1.osrc.amd.com>
References: <CAKgfjTktMLc5bfqhCOKy0evssxggofNQqLT-gQqBkHcBvOgF0g@mail.gmail.com>
 <CAKgfjTnvCAT=3JFxmDTsui_hguiiBfHQfMmErv9wt6QG_30hKA@mail.gmail.com>
 <20120607142459.GB5053@x1.osrc.amd.com> <CAKgfjTn3KXmDio0F0M3syeHnDc=ByKZu1ipe7S+75KRcCBy0QA@mail.gmail.com>
 <20120607151352.GA8261@x1.osrc.amd.com>
From: Rus <rus@sfinxsoft.com>
Date: Fri, 8 Jun 2012 00:00:59 +0300
X-Google-Sender-Auth: xsF4wf9y9u0IYAwivPVP7wVsqM8
Message-ID: <CAKgfjTkAn88JTNyoZk-9u-nZFQUx_MHg6A31C4tVhbB38N-EEg@mail.gmail.com>
Subject: Re: 3.[34].x Reproducable [Firmware bug] message upon warm boot only
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More info:

Tried to switch off the IOMMU in the BIOS:

3.4.1 boots, but onboard ethernet is not woking with the previously
posted net/sched/sch_generic.c:256 warning.
3.5-rc1 fails to boot due to AHCI timeouts

If the at the same time the USB3.0 controller is disabled in the BIOS
- for both kernels the USB keyboard do not work (the 3.5-rc1 can't
load the usb modules though) even in USB2.0 ports. If the USB3.0 is
enabled in the BIOS - the USB keyboard works only in USB3.0 ports -
the USB2.0 ports are failed with the device descriptor read errors. By
the way: people with the older kernels and older BIOS'es struggles
from the same problem on the same m/b -
http://www.spinics.net/lists/linux-usb/msg54761.html

After re-enabling the IOMMU the keyboard and ethernet became work
again. This is somewhat strange as week ago I've observed exact the
opposite behaviour - the Ethernet works only with IOMMU switched off.
USB was bugging as described - works only in USB3.0 ports. Seems like
some random bug hits the IOMMU subsystem or this motherboard need to
be thrown away.

As usual can supply any additional info.

Rus

-- 
SfinxSoft
http://sfinxsoft.com
