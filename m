Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab2BHBJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 20:09:45 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:37912 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754189Ab2BHBJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 20:09:43 -0500
MIME-Version: 1.0
In-Reply-To: <4F31B789.9020509@samsung.com>
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
Date: Wed, 8 Feb 2012 09:09:43 +0800
Message-ID: <CAAJw_ZtnWYxGCm5Vm5CQ1GBLc=GU7AGiQKe_-9LJsbMW+YG-GQ@mail.gmail.com>
Subject: Re: mmc sdhci mmcblk0: error -110 sending status command, retrying
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Philip Rakity <prakity@marvell.com>, Chris Ball <cjb@laptop.org>,
        Pierre Ossman <pierre@ossman.eu>, lkml <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, arindam.nath@amd.com,
        zhangfei.gao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 7:45 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> On 02/08/2012 03:33 AM, Jeff Chua wrote:

I tried a Class6 8GB and after a few inserts, it could read without
errors. The Class10 seems to be more sensitive to speed.

Jeff
