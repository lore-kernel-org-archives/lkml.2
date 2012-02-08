Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2BHTJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:09:52 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:55108 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621Ab2BHTJv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:09:51 -0500
From: Philip Rakity <prakity@marvell.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        Pierre Ossman <pierre@ossman.eu>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "arindam.nath@amd.com" <arindam.nath@amd.com>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>
Date: Wed, 8 Feb 2012 11:09:26 -0800
Subject: Re: mmc sdhci mmcblk0: error -110 sending status command, retrying
Thread-Topic: mmc sdhci mmcblk0: error -110 sending status command, retrying
Thread-Index: AczmlS1uyIXhI8u5R9abUCeSTeOkHg==
Message-ID: <15D4F59C-7AFA-456E-8A5F-9E11EE9B9717@marvell.com>
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
In-Reply-To: <CAAJw_ZtnWYxGCm5Vm5CQ1GBLc=GU7AGiQKe_-9LJsbMW+YG-GQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jeff,

I think the sdhci.c clock setting code was changed a while ago.   Maybe revert that mod and see what happens.

The card is a 24MHz which is rather slow so I would be surprised if that was it. 
The other option is the force enable the High Speed bit in the  controller (used when speed is 25MHz or faster).  Will give the system more time (in theory) to work.  

Philip

On Feb 7, 2012, at 5:09 PM, Jeff Chua wrote:

> On Wed, Feb 8, 2012 at 7:45 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> On 02/08/2012 03:33 AM, Jeff Chua wrote:
> 
> I tried a Class6 8GB and after a few inserts, it could read without
> errors. The Class10 seems to be more sensitive to speed.
> 
> Jeff

