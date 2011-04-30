Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1D3Le7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 07:34:59 -0400
Received: from smtpout06.highway.telekom.at ([195.3.96.89]:5597 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753970Ab1D3Le6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 07:34:58 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: i915/kms/backlight-combo mode problem (was: Re: Linux 2.6.39-rc5)
Date: Sat, 30 Apr 2011 13:34:51 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.4; KDE/4.6.0; x86_64; ; )
Cc: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
        Carlos Corbacho <carlos@strangeworlds.co.uk>
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <201104301032.05271@rk-nord.at> <s5hiptwavar.wl%tiwai@suse.de>
In-Reply-To: <s5hiptwavar.wl%tiwai@suse.de>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104301334.53928@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropping Linus from the CC.


* Takashi Iwai -- Saturday 30 April 2011:
* * At Sat, 30 Apr 2011 10:32:04 +0200, Melchior FRANZ wrote:
> > Yes, backlight adjustment generally works on this notebook, but only
> > with "acpi_osi=Linux" on the command line.
> 
> acpi_osi quirk should be better added statically, then.

No, I guess the problem here is that acer_wmi doesn't support this
machine yet. I told the ACER WMI maintainer and sent a DSDT image,
but this message was thoroughly ignored.


  $ dmesg|grep -i acer
  [    0.000000] DMI: Acer TM5735/BA51_MV, BIOS V1.04 09/23/2010
  [   71.850534] acer_wmi: Acer Laptop ACPI-WMI Extras
  [   72.350278] acer_wmi: Unable to detect available WMID devices
  
  Machine: Acer Travelmate 5735Z-452G32Mnss

m.
