Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab2BMElU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 23:41:20 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39921 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025Ab2BMElS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 23:41:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAAJw_Zu=M7R5cyVRmbd3Tz7MipgX_b5J4g5Z4m+SsiHP-3Uxgw@mail.gmail.com>
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
Date: Mon, 13 Feb 2012 12:41:18 +0800
Message-ID: <CAAJw_ZuQaDka+xKfwfvZCkPwfqJNsd6+UC4bfww=_G1XhaS5QA@mail.gmail.com>
Subject: Re: mmc sdhci mmcblk0: error -110 sending status command, retrying
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Philip Rakity <prakity@marvell.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        Pierre Ossman <pierre@ossman.eu>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "arindam.nath@amd.com" <arindam.nath@amd.com>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 11, 2012 at 6:55 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> sdhci: Secure Digital Host Controller Interface driver
> sdhci: Copyright(c) Pierre Ossman
> sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e823] (rev 4)
> Registered led device: mmc0::
> mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
> mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
> mmc0: clock 0Hz busmode 2 powermode 1 cs 0 Vdd 21 width 0 timing 0
> mmc0: clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 21 width 0 timing 0
> mmc0: clock 400000Hz busmode 2 powermode 2 cs 1 Vdd 21 width 0 timing 0
> mmc0: clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 21 width 0 timing 0
> mmc0: clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 0 timing 0
> mmc0: clock 400000Hz busmode 2 powermode 2 cs 1 Vdd 20 width 0 timing 0
> mmc0: clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 0 timing 0
> hz 25000000 min 16129 max 33000000 ios 400000
> mmc0: clock 10000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 0 timing 0
> mmc0: clock 10000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
> mmc0: new SDHC card at address b368
> mmcblk0: mmc0:b368 H1109 14.9 GiB (ro)
> mmcblk0: p1
> mmc0: clock 0Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
> hz 10000000 min 16129 max 33000000 ios 0
> mmc0: clock 10000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
> mmc0: clock 0Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
> hz 10000000 min 16129 max 33000000 ios 0
> mmc0: clock 10000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
> mmc0: clock 0Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
> hz 10000000 min 16129 max 33000000 ios 0
> mmc0: clock 10000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
> mmc0: clock 0Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
> hz 10000000 min 16129 max 33000000 ios 0
> mmc0: clock 10000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
>
>
> Hope this helps. Also, I've tried setting hz to 20000000 but
> encountered random errors.

I ran tests for frequency that works dd out 1G of data from 8MHz to
16MHz, and it seems frequency less than 8.4MHz can only transfer at
rate of 14.3MB/s and above 8.4MHz, speed goes up to 18.3 MB/s. Above
17MHz, errors encounters.

hz1  8000000  73.5029 s  14.3 MB/s
hz2  8000000  73.4740 s  14.3 MB/s
hz3  8000000  73.3982 s  14.3 MB/s
hz1  8200000  71.9677 s  14.6 MB/s
hz2  8200000  73.4936 s  14.3 MB/s
hz3  8200000  73.3462 s  14.3 MB/s
hz1  8400000  56.6296 s  18.5 MB/s
hz2  8400000  56.7616 s  18.5 MB/s
hz3  8400000  56.7926 s  18.5 MB/s
hz1  8600000  56.6622 s  18.5 MB/s
hz2  8600000  56.7201 s  18.5 MB/s
hz3  8600000  56.6476 s  18.5 MB/s
hz1  8800000  56.8846 s  18.4 MB/s
hz2  8800000  56.8226 s  18.5 MB/s
hz3  8800000  56.7070 s  18.5 MB/s
hz1  9000000  56.7007 s  18.5 MB/s
hz2  9000000  56.6931 s  18.5 MB/s
hz3  9000000  56.7465 s  18.5 MB/s
hz1  9200000  56.7813 s  18.5 MB/s
hz2  9200000  56.9230 s  18.4 MB/s
hz3  9200000  56.8489 s  18.4 MB/s
hz1  9400000  57.3411 s  18.3 MB/s
hz2  9400000  56.5798 s  18.5 MB/s
hz3  9400000  56.9512 s  18.4 MB/s
hz1  9600000  56.6263 s  18.5 MB/s
hz2  9600000  56.8361 s  18.4 MB/s
hz3  9600000  56.9943 s  18.4 MB/s
hz1  9800000  56.8875 s  18.4 MB/s
hz2  9800000  56.7966 s  18.5 MB/s
hz3  9800000  56.9299 s  18.4 MB/s
hz1 10000000  56.7702 s  18.5 MB/s
hz2 10000000  56.7131 s  18.5 MB/s
hz3 10000000  56.7559 s  18.5 MB/s
hz1 10200000  56.8087 s  18.5 MB/s
hz2 10200000  57.0066 s  18.4 MB/s
hz3 10200000  57.4178 s  18.3 MB/s
hz1 10400000  57.0445 s  18.4 MB/s
hz2 10400000  57.2470 s  18.3 MB/s
hz3 10400000  57.3996 s  18.3 MB/s
hz1 10600000  57.0698 s  18.4 MB/s
hz2 10600000  56.9447 s  18.4 MB/s
hz3 10600000  57.0124 s  18.4 MB/s
hz1 10800000  56.8901 s  18.4 MB/s
hz2 10800000  57.3534 s  18.3 MB/s
hz3 10800000  56.7887 s  18.5 MB/s
hz1 11000000  56.9826 s  18.4 MB/s
hz2 11000000  56.8821 s  18.4 MB/s
hz3 11000000  57.1497 s  18.3 MB/s
hz1 11200000  56.6727 s  18.5 MB/s
hz2 11200000  57.3771 s  18.3 MB/s
hz3 11200000  57.2056 s  18.3 MB/s
hz1 11400000  57.0076 s  18.4 MB/s
hz2 11400000  57.1330 s  18.4 MB/s
hz3 11400000  57.4008 s  18.3 MB/s
hz1 11600000  57.1187 s  18.4 MB/s
hz2 11600000  57.1042 s  18.4 MB/s
hz3 11600000  56.9396 s  18.4 MB/s
hz1 11800000  57.1824 s  18.3 MB/s
hz2 11800000  57.0874 s  18.4 MB/s
hz3 11800000  57.4669 s  18.2 MB/s
hz1 12000000  57.0121 s  18.4 MB/s
hz2 12000000  57.0706 s  18.4 MB/s
hz3 12000000  57.0935 s  18.4 MB/s
hz1 12200000  57.3944 s  18.3 MB/s
hz2 12200000  57.5170 s  18.2 MB/s
hz3 12200000  57.0330 s  18.4 MB/s
hz1 12400000  56.8146 s  18.5 MB/s
hz2 12400000  57.2807 s  18.3 MB/s
hz3 12400000  57.1569 s  18.3 MB/s
hz1 12600000  57.3627 s  18.3 MB/s
hz2 12600000  57.2619 s  18.3 MB/s
hz3 12600000  57.1370 s  18.4 MB/s
hz1 12800000  57.3385 s  18.3 MB/s
hz2 12800000  57.2734 s  18.3 MB/s
hz3 12800000  57.0400 s  18.4 MB/s
hz1 13000000  56.9019 s  18.4 MB/s
hz2 13000000  57.1484 s  18.3 MB/s
hz3 13000000  57.2854 s  18.3 MB/s
hz1 13200000  57.3357 s  18.3 MB/s
hz2 13200000  57.2955 s  18.3 MB/s
hz3 13200000  57.1439 s  18.3 MB/s
hz1 13400000  57.2260 s  18.3 MB/s
hz2 13400000  57.3871 s  18.3 MB/s
hz3 13400000  57.1127 s  18.4 MB/s
hz1 13600000  57.4000 s  18.3 MB/s
hz2 13600000  56.9386 s  18.4 MB/s
hz3 13600000  57.4267 s  18.3 MB/s
hz1 13800000  57.3932 s  18.3 MB/s
hz2 13800000  56.8886 s  18.4 MB/s
hz3 13800000  57.0506 s  18.4 MB/s
hz1 14000000  57.2435 s  18.3 MB/s
hz2 14000000  57.0724 s  18.4 MB/s
hz3 14000000  57.3697 s  18.3 MB/s
hz1 14200000  57.3237 s  18.3 MB/s
hz2 14200000  57.3678 s  18.3 MB/s
hz3 14200000  57.1647 s  18.3 MB/s
hz1 14400000  57.1770 s  18.3 MB/s
hz2 14400000  57.2560 s  18.3 MB/s
hz3 14400000  57.4751 s  18.2 MB/s
hz1 14600000  57.1345 s  18.4 MB/s
hz2 14600000  57.2170 s  18.3 MB/s
hz3 14600000  57.2803 s  18.3 MB/s
hz1 14800000  57.0580 s  18.4 MB/s
hz2 14800000  56.8908 s  18.4 MB/s
hz3 14800000  57.0882 s  18.4 MB/s
hz1 15000000  57.2161 s  18.3 MB/s
hz2 15000000  57.3606 s  18.3 MB/s
hz3 15000000  57.1794 s  18.3 MB/s
hz1 15200000  57.1266 s  18.4 MB/s
hz2 15200000  57.1371 s  18.4 MB/s
hz3 15200000  56.6513 s  18.5 MB/s
hz1 15400000  57.3680 s  18.3 MB/s
hz2 15400000  56.9819 s  18.4 MB/s
hz3 15400000  57.2429 s  18.3 MB/s
hz1 15600000  57.4191 s  18.3 MB/s
hz2 15600000  57.0848 s  18.4 MB/s
hz3 15600000  56.9853 s  18.4 MB/s
hz1 15800000  57.2306 s  18.3 MB/s
hz2 15800000  56.9850 s  18.4 MB/s
hz3 15800000  57.3068 s  18.3 MB/s
hz1 16000000  57.1337 s  18.4 MB/s
hz2 16000000  57.0935 s  18.4 MB/s
hz3 16000000  57.2745 s  18.3 MB/s

Thanks,
Jeff
