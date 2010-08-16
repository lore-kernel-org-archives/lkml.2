Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0HPMtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:49:18 -0400
Received: from dakia3.marvell.com ([65.219.4.28]:58273 "EHLO
	dakia3.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab0HPMtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:49:17 -0400
X-ASG-Debug-ID: 1281962956-6c3bfddf0001-xx1T2L
X-Barracuda-Envelope-From: hzhuang1@marvell.com
From: Haojian Zhuang <hzhuang1@marvell.com>
X-Barracuda-BBL-IP: 10.93.76.137
X-Barracuda-RBL-IP: 10.93.76.137
To: Eric Miao <eric.y.miao@gmail.com>, Lei Wen <leiwen@marvell.com>
CC: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Date: Mon, 16 Aug 2010 05:49:13 -0700
X-ASG-Orig-Subj: RE: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for
 samsung2GbX8
Subject: RE: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for
 samsung2GbX8
Thread-Topic: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for
 samsung2GbX8
Thread-Index: Acs9QMJayf3QJNTPR6GHJHCWa2llQgAAGd5g
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C0597FEB568@SC-VEXCH1.marvell.com>
References: <AANLkTi=YSS0-Nf4MWOw30YDrCdrkmtzLhv7DXfsoJTjX@mail.gmail.com>
 <53612FE6B944314AAADB181E45A45B64133DDFC156@sc-vexch3.marvell.com>
 <AANLkTimh=dbUV75ZVXuhknt4FiMtximXLY8xoADfbe=q@mail.gmail.com>
In-Reply-To: <AANLkTimh=dbUV75ZVXuhknt4FiMtximXLY8xoADfbe=q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Barracuda-Connect: sc-owa01.marvell.com[10.93.76.21]
X-Barracuda-Start-Time: 1281962956
X-Barracuda-Encrypted: RC4-MD5
X-Barracuda-URL: http://dakia3.marvell.com:80/cgi-mod/mark.cgi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7GCnVea000572

http://lists.infradead.org/pipermail/linux-mtd/2010-July/subject.html

They're re-posted in July. Please search the subjects in that page. They're totally 29 patches.

By the way, David, what's the result of review on these patches? We already posted for several times.

Thanks
Haojian

-----Original Message-----
From: Eric Miao [mailto:eric.y.miao@gmail.com] 
Sent: 2010å¹´8æœˆ16æ—¥ 8:44 PM
To: Lei Wen
Cc: Axel Lin; linux-kernel; David Woodhouse; linux-mtd@lists.infradead.org; Haojian Zhuang
Subject: Re: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for samsung2GbX8

On Mon, Aug 16, 2010 at 8:34 PM, Lei Wen <leiwen@marvell.com> wrote:
> Hi Axel,
>
> I suggest not merge your patch into mainline code. Since I have a large series of patch which reconstruct the nand flash definition, this fix would no longer be needed.
>

Lei, would you please point the URL of the patch series (possibly by
searching linux-mtd archive or some other mailing list archive) so that
Axel can have a reference and be involved?

- eric
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
