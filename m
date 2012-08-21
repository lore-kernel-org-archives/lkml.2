Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab2HUJh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:37:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53261 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab2HUJhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:37:23 -0400
Date: Tue, 21 Aug 2012 11:37:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: "mr.shroom" <mr.shroom@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Bug report
Message-ID: <20120821093719.GB21368@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"mr.shroom" <mr.shroom@gmail.com>, linux-kernel@vger.kernel.org,
	linux-ide <linux-ide@vger.kernel.org>
References: <CAL=PgHMH=5A5rLaO=RvYYA8MmcKEt1zay7f2=SS83RYayVVh+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL=PgHMH=5A5rLaO=RvYYA8MmcKEt1zay7f2=SS83RYayVVh+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding linux-ide.

Please send also full dmesg of the box.

Thanks.

On Mon, Aug 20, 2012 at 05:31:44PM -0500, mr.shroom wrote:
> SATA for kernel(s) 3.5+ has an issue with IRQ Balancing on AMD SB710
> with motherboard ASRock m3a770d3.
> 
> The problem started while using Arch linux, after going back to Debian
> it persisted.  I had tried to find problems with the bug but couldn't
> find any direct help online.  I had a break when finding similar bugs
> on other sites stating that IRQ Balancing might be the fault.  So I
> tried ACPI_IRQ_NOBALANCE in the kernel boot parameters and so far the
> issue has stopped.
> 
> Linux version 3.6.0-rc2 (mboy@debian) (gcc version 4.7.1 (Debian
> 4.7.1-6) ) #1 SMP Sat Aug 18 00:46:06 CDT 2012
> 
> Aug 20 12:32:08 debian kernel: [42238.075368] ata4.00: exception Emask
> 0x0 SAct 0x7f SErr 0x0 action 0x6 frozen
> Aug 20 12:32:08 debian kernel: [42238.075373] ata4.00: failed command:
> WRITE FPDMA QUEUED
> Aug 20 12:32:08 debian kernel: [42238.075377] ata4.00: cmd
> 61/08:00:c8:0a:89/00:00:01:00:00/40 tag 0 ncq 4096 out
> Aug 20 12:32:08 debian kernel: [42238.075377]          res
> 40/00:00:00:4f:c2/00:00:00:4f:c2/00 Emask 0x4 (timeout)
> Aug 20 12:32:08 debian kernel: [42238.075379] ata4.00: status: { DRDY }
> Aug 20 12:32:08 debian kernel: [42238.075381] ata4.00: failed command:
> WRITE FPDMA QUEUED
> Aug 20 12:32:08 debian kernel: [42238.075384] ata4.00: cmd
> 61/08:08:f8:cb:8a/00:00:03:00:00/40 tag 1 ncq 4096 out
> Aug 20 12:32:08 debian kernel: [42238.075384]          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Aug 20 12:32:08 debian kernel: [42238.075386] ata4.00: status: { DRDY }
> Aug 20 12:32:08 debian kernel: [42238.075388] ata4.00: failed command:
> WRITE FPDMA QUEUED
> Aug 20 12:32:08 debian kernel: [42238.075391] ata4.00: cmd
> 61/10:10:80:95:86/00:00:08:00:00/40 tag 2 ncq 8192 out
> Aug 20 12:32:08 debian kernel: [42238.075391]          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Aug 20 12:32:08 debian kernel: [42238.075393] ata4.00: status: { DRDY }
> Aug 20 12:32:08 debian kernel: [42238.075394] ata4.00: failed command:
> READ FPDMA QUEUED
> Aug 20 12:32:08 debian kernel: [42238.075397] ata4.00: cmd
> 60/60:18:60:71:62/00:00:00:00:00/40 tag 3 ncq 49152 in
> Aug 20 12:32:08 debian kernel: [42238.075397]          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Aug 20 12:32:08 debian kernel: [42238.075399] ata4.00: status: { DRDY }
> Aug 20 12:32:08 debian kernel: [42238.075401] ata4.00: failed command:
> READ FPDMA QUEUED
> Aug 20 12:32:08 debian kernel: [42238.075404] ata4.00: cmd
> 60/08:20:c8:71:62/00:00:00:00:00/40 tag 4 ncq 4096 in
> Aug 20 12:32:08 debian kernel: [42238.075404]          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Aug 20 12:32:08 debian kernel: [42238.075406] ata4.00: status: { DRDY }
> Aug 20 12:32:08 debian kernel: [42238.075407] ata4.00: failed command:
> READ FPDMA QUEUED
> Aug 20 12:32:08 debian kernel: [42238.075410] ata4.00: cmd
> 60/18:28:d8:71:62/00:00:00:00:00/40 tag 5 ncq 12288 in
> Aug 20 12:32:08 debian kernel: [42238.075410]          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Aug 20 12:32:08 debian kernel: [42238.075412] ata4.00: status: { DRDY }
> Aug 20 12:32:08 debian kernel: [42238.075413] ata4.00: failed command:
> READ FPDMA QUEUED
> Aug 20 12:32:08 debian kernel: [42238.075417] ata4.00: cmd
> 60/08:30:f8:71:62/00:00:00:00:00/40 tag 6 ncq 4096 in
> Aug 20 12:32:08 debian kernel: [42238.075417]          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Aug 20 12:32:08 debian kernel: [42238.075418] ata4.00: status: { DRDY }
> Aug 20 12:32:08 debian kernel: [42238.075422] ata4: hard resetting link
> 
> After it would reset, it would try SATA I, fail, then mount the drive
> as RO.  I'm running a Phenom II on Debian Wheezy with a bit of Sid,
> don't have the time at the moment to get a better grasp on what you
> need for a proper bug report but I hope this helps.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.
