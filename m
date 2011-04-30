Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab1D3OiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 10:38:07 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:38457 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754994Ab1D3OiD (ORCPT
	<rfc822;groupwise-jlee@novell.com:6:1>);
	Sat, 30 Apr 2011 10:38:03 -0400
Message-Id: <4DBCAB61020000230002C040@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Sat, 30 Apr 2011 08:37:53 -0600
From: "Joey Lee" <jlee@novell.com>
To: <melchior.franz@gmail.com>
Cc: <chris@chris-wilson.co.uk>, <dri-devel@lists.freedesktop.org>,
        <carlos@strangeworlds.co.uk>, <tiwai@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: i915/kms/backlight-combo mode problem (was: Re: Linux
 2.6.39-rc5)
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com>
 <201104301032.05271@rk-nord.at> <s5hiptwavar.wl%tiwai@suse.de>
 <201104301334.53928@rk-nord.at>
In-Reply-To: <201104301334.53928@rk-nord.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Melchior, 

於 六，2011-04-30 於 13:34 +0200，Melchior FRANZ 提到：
> Dropping Linus from the CC.
> 
> 
> * Takashi Iwai -- Saturday 30 April 2011:
> * * At Sat, 30 Apr 2011 10:32:04 +0200, Melchior FRANZ wrote:
> > > Yes, backlight adjustment generally works on this notebook, but only
> > > with "acpi_osi=Linux" on the command line.
> > 
> > acpi_osi quirk should be better added statically, then.
> 
> No, I guess the problem here is that acer_wmi doesn't support this
> machine yet. I told the ACER WMI maintainer and sent a DSDT image,
> but this message was thoroughly ignored.
> 
> 
>   $ dmesg|grep -i acer
>   [    0.000000] DMI: Acer TM5735/BA51_MV, BIOS V1.04 09/23/2010
>   [   71.850534] acer_wmi: Acer Laptop ACPI-WMI Extras
>   [   72.350278] acer_wmi: Unable to detect available WMID devices
>   
>   Machine: Acer Travelmate 5735Z-452G32Mnss
> 
> m.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Could you please attach DSDT on this mail or share your kernel bugzilla
number to us?

I found cann't access BKO now?


Thank's
Joey Lee

