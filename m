Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab2BMFQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:16:36 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55334 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873Ab2BMFQf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:16:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAAJw_ZuQaDka+xKfwfvZCkPwfqJNsd6+UC4bfww=_G1XhaS5QA@mail.gmail.com>
References: <CAAJw_ZsryUFFFRCKdd9sQ7_38hjpVq37b6hhZDX5=qz8x1B+EQ@mail.gmail.com>
	<m2pqdr2tyq.fsf@bob.laptop.org>
	<CAAJw_Zv4Hk_kfc33xsVcdi-0_C6tsf_FD3sUx1JPDX_fZZMzeQ@mail.gmail.com>
	<4F30E19B.9020503@intel.com>
	<CAAJw_Zth+QM8OhMEWweBBek8QNW_9CseHSDuB-LCGrvwuqfV2A@mail.gmail.com>
	<4F310529.4020101@intel.com>
	<CAAJw_ZsHwdvXuw+edXUfyGOSMOu5oUw3zX8nUryxJJiiZXzXKQ@mail.gmail.com>
	<CAAJw_Zup7Wg7FO95Z63e_sniu21gyzdCjcBNgsS0aw6MguDwLw@mail.gmail.com>
	<CAAJw_Zv6HkLLqEzNKRCfQ7EbMNEVe_hzbW+mHOnDAWLidOhMBQ@mail.gmail.com>
	<CAAJw_Zs7aET=vdy033bzuHwW==uS8AW78NSvD2L_hjU+Mzp-_w@mail.gmail.com>
	<4F31B789.9020509@samsung.com>
	<CAAJw_ZtnWYxGCm5Vm5CQ1GBLc=GU7AGiQKe_-9LJsbMW+YG-GQ@mail.gmail.com>
	<15D4F59C-7AFA-456E-8A5F-9E11EE9B9717@marvell.com>
	<CAAJw_Zs+Jz9WiJd6254Zkj+Y76w9W3CqZTgGrLYRRsjuxnqTyw@mail.gmail.com>
	<4B11A480-8122-4A0B-A0EE-E1E95477F985@marvell.com>
	<CAAJw_Zu=M7R5cyVRmbd3Tz7MipgX_b5J4g5Z4m+SsiHP-3Uxgw@mail.gmail.com>
	<CAAJw_ZuQaDka+xKfwfvZCkPwfqJNsd6+UC4bfww=_G1XhaS5QA@mail.gmail.com>
Date: Mon, 13 Feb 2012 13:16:34 +0800
Message-ID: <CAAJw_Zsxj9VKpnB7fGWnkqRUKG1DahCV6dKyGTfeAybhqn4KUw@mail.gmail.com>
Subject: Re: mmc sdhci mmcblk0: error -110 sending status command, retrying
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Philip Rakity <prakity@marvell.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        Pierre Ossman <pierre@ossman.eu>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "arindam.nath@amd.com" <arindam.nath@amd.com>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 12:41 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> I ran tests for frequency that works dd out 1G of data from 8MHz to
> 16MHz, and it seems frequency less than 8.4MHz can only transfer at
> rate of 14.3MB/s and above 8.4MHz, speed goes up to 18.3 MB/s. Above
> 17MHz, errors encounters.
>
> hz1  8000000  73.5029 s  14.3 MB/s
> hz2  8000000  73.4740 s  14.3 MB/s
> hz3  8000000  73.3982 s  14.3 MB/s
> hz1  8200000  71.9677 s  14.6 MB/s
> hz2  8200000  73.4936 s  14.3 MB/s
> hz3  8200000  73.3462 s  14.3 MB/s
> hz1  8400000  56.6296 s  18.5 MB/s
> hz2  8400000  56.7616 s  18.5 MB/s
> hz3  8400000  56.7926 s  18.5 MB/s
> hz1  8600000  56.6622 s  18.5 MB/s
> hz2  8600000  56.7201 s  18.5 MB/s
> hz3  8600000  56.6476 s  18.5 MB/s
> hz1  8800000  56.8846 s  18.4 MB/s
> hz2  8800000  56.8226 s  18.5 MB/s
> hz3  8800000  56.7070 s  18.5 MB/s

I've turned on write, and there's no error writing. But speed is
slower than accessing it via USB2 SD card reader. Same SD.

Via SD PCI
8.779 sec  4.04 %cpu
Via USB Reader
