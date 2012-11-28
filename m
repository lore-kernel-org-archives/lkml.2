Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab2K1PMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:12:54 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45621 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301Ab2K1PMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:12:52 -0500
Date: Wed, 28 Nov 2012 16:12:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Denis Lotarev <dlotarev@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: Re: [FIRMWARE BUG] Lenovo x120e
Message-ID: <20121128151247.GA14635@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Denis Lotarev <dlotarev@yahoo.com>, linux-kernel@vger.kernel.org,
	Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
References: <1354109265.69986.YahooMailClassic@web163004.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354109265.69986.YahooMailClassic@web163004.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 05:27:45AM -0800, Denis Lotarev wrote:
> Im using kernel (Linux initbox 3.6.7-1-ARCH #1 SMP PREEMPT Sun Nov 18 10:11:22 CET 2012 x86_64 GNU/Linux) and i see some problems at booting... So dmesg output with BUG lines:
> 
> $ dmesg |grep Bug
> [    1.363154] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    1.373784] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
> [    1.380827] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
> [    1.433354] pnp 00:09: [Firmware Bug]: [mem 0x00000000-0xffffffffffffffff disabled] covers only part of AMD MMCONFIG area [mem 0xf8000000-0xf9ffffff]; adding more reservations
> [    3.349658] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness

Nothing to worry about, just ACPI in BIOS is not implementing _BQC
method with which you can query the initial brightness level of the
display device. Frankly, I'm not getting any smarter from the commit
message as to what it even got added for:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=98758faffc86ee6fe9504eeab75481ee7c1aa860

"kinda firmware bug"?? :-)

Maybe Zhang/Len can shed more light on the matter.

Thanks.

-- 
Regards/Gruss,
    Boris.
