Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab2LWI1K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 03:27:10 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:54443 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2LWI1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 03:27:08 -0500
X-Greylist: delayed 60787 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Dec 2012 03:27:08 EST
MIME-Version: 1.0
In-Reply-To: <50D6AFF2.1010708@gmail.com>
References: <CAJiejCRCXgCw957to0fWhQPS69doacY9DOaQMpfyxM4bm3igQw@mail.gmail.com>
 <50D6AFF2.1010708@gmail.com>
From: Drunkard Zhang <gongfan193@gmail.com>
Date: Sun, 23 Dec 2012 16:26:47 +0800
Message-ID: <CAJiejCQXQWztiA8ksfRmxqx969FFpuL3DXH=EXmbOkYHE6VA5g@mail.gmail.com>
Subject: Re: mvsas regression since 3.5
To: Xi Wang <xi.wang@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jack Wang <jack_wang@usish.com>, Xiangliang Yu <yuxiangl@marvell.com>,
        linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/23 Xi Wang <xi.wang@gmail.com>:
> On 12/22/12 10:33 AM, Drunkard Zhang wrote:
>> I'm using Asus PIKE 6480 SAS card, whose chipset is "RAID bus
>> controller: Marvell Technology Group Ltd. MV64460/64461/64462 System
>> Controller, Revision B", with latest stable branch 3.7.1 only 1 of 8
>> ports works, to get others works I got to pull & plug back. While with
>> 3.5.7 it's all good, so it must be a regression.
>
> Can you try to revert commit beecadea1b8d67f591b13f7099559f32f3fd601d?
>
> Particularly, can you first change
>
>   #define bit(n) ((u64)1 << n)
>
> in drivers/scsi/mvsas/mv_sas.h back to
>
>   #define bit(n) ((u32)1 << n)
>
> and see if it works for you?  Thanks.
>

Thanks for reply.

This commit just applied in v3.8-rc1, so can't be it. I'm testing
related commits too...
