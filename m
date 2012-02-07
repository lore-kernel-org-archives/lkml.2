Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2BGQBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:01:03 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:49395 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302Ab2BGQBB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:01:01 -0500
MIME-Version: 1.0
In-Reply-To: <4F310529.4020101@intel.com>
References: <CAAJw_ZsryUFFFRCKdd9sQ7_38hjpVq37b6hhZDX5=qz8x1B+EQ@mail.gmail.com>
	<m2pqdr2tyq.fsf@bob.laptop.org>
	<CAAJw_Zv4Hk_kfc33xsVcdi-0_C6tsf_FD3sUx1JPDX_fZZMzeQ@mail.gmail.com>
	<4F30E19B.9020503@intel.com>
	<CAAJw_Zth+QM8OhMEWweBBek8QNW_9CseHSDuB-LCGrvwuqfV2A@mail.gmail.com>
	<4F310529.4020101@intel.com>
Date: Wed, 8 Feb 2012 00:01:01 +0800
Message-ID: <CAAJw_ZsHwdvXuw+edXUfyGOSMOu5oUw3zX8nUryxJJiiZXzXKQ@mail.gmail.com>
Subject: Re: mmc sdhci mmcblk0: error -110 sending status command, retrying
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Chris Ball <cjb@laptop.org>, Pierre Ossman <pierre@ossman.eu>,
        lkml <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org,
        arindam.nath@amd.com, zhangfei.gao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 7:04 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> On 07/02/12 12:40, Jeff Chua wrote:
>> On Tue, Feb 7, 2012 at 4:32 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
>>
>>> Looks like Caps_1: 0x00008073 means re-tuning mode 3.  Maybe the tuning is
>>> not being done correctly.
>>
>> What I can do to test it?
>
> Tuning may be needed for UHS (ultra high speed).
> Was there a message like:
>
>        mmc0: new ultra high speed SDHC card

Nop. Just this one (I'm using a 16GB microSD that's plugged in via a
SD card adaptor).

mmc0: new SDHC card at address b368


Thanks,
Jeff
