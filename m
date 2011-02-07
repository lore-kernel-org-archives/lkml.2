Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab1BGFdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 00:33:39 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:42826 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365Ab1BGFdi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 00:33:38 -0500
MIME-Version: 1.0
In-Reply-To: <87zkqbjtrd.fsf@ti.com>
References: <cover.1296818921.git.segoon@openwall.com> <96a2b24548af3a68fde712c68b49e856e53ea1fc.1296818921.git.segoon@openwall.com>
 <87zkqbjtrd.fsf@ti.com>
From: "Menon, Nishanth" <nm@ti.com>
Date: Mon, 7 Feb 2011 11:03:15 +0530
Message-ID: <AANLkTinMBQZa+-_T4O1dOZcUGjOM4748J+m_WmEV=LXW@mail.gmail.com>
Subject: Re: [PATCH 03/20] mach-omap2: smartreflex: world-writable debugfs
 voltage files
To: Kevin Hilman <khilman@ti.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 5, 2011 at 04:24, Kevin Hilman <khilman@ti.com> wrote:
> Vasiliy Kulikov <segoon@openwall.com> writes:
>
>> Don't allow everybody to change voltage settings.
>>
>> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
>> ---
>>  Cannot compile the driver, so it is not tested at all.
>
> Acked-by: Kevin Hilman <khilman@ti.com>
Also fixes the checkpatch warning:
scripts/checkpatch.pl -f arch/arm/mach-omap2/smartreflex.c
WARNING: Exporting world writable files is usually an error. Consider
more restrictive permissions.
#903: FILE: arm/mach-omap2/smartreflex.c:903:
+	(void) debugfs_create_file("autocomp", S_IRUGO | S_IWUGO, dbg_dir,

total: 0 errors, 1 warnings, 1028 lines checked

Acked-by: Nishanth Menon <nm@ti.com>

Regards,
Nishanth Menon
