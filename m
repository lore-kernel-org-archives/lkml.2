Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0HPODP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:03:15 -0400
Received: from dakia3.marvell.com ([65.219.4.28]:36807 "EHLO
	dakia3.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab0HPODO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:03:14 -0400
X-ASG-Debug-ID: 1281967393-6c3a12be0001-xx1T2L
X-Barracuda-Envelope-From: leiwen@marvell.com
From: Lei Wen <leiwen@marvell.com>
X-Barracuda-BBL-IP: 10.93.76.133
X-Barracuda-RBL-IP: 10.93.76.133
To: Eric Miao <eric.y.miao@gmail.com>, David Woodhouse <dwmw2@infradead.org>
CC: Haojian Zhuang <hzhuang1@marvell.com>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Date: Mon, 16 Aug 2010 07:03:11 -0700
X-ASG-Orig-Subj: RE: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for
 samsung2GbX8
Subject: RE: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for
 samsung2GbX8
Thread-Topic: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for
 samsung2GbX8
Thread-Index: Acs9SrN/qt+bvrxLS0i9q5GHxhnxMAAADXfQ
Message-ID: <53612FE6B944314AAADB181E45A45B64133DDFC162@sc-vexch3.marvell.com>
In-Reply-To: <AANLkTikCO505BZfqQGsRAdLgMa9hBQZ8YS-hJy-1RGg1@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Barracuda-Connect: sc-owa01.marvell.com[10.93.76.21]
X-Barracuda-Start-Time: 1281967393
X-Barracuda-Encrypted: RC4-MD5
X-Barracuda-URL: http://dakia3.marvell.com:80/cgi-mod/mark.cgi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7GE3Vml001062

Eric,
The first patch is a bit of fundamental. I'm afraid that modify it would bring changes to all latter patches in this series...

So I think I would repost another round of updating patch series and hope that would be merged. How do you think about this?

Thanks,
Lei



-----Original Message-----
From: Eric Miao [mailto:eric.y.miao@gmail.com] 
Sent: 2010Äê8ÔÂ16ÈÕ 21:55
To: David Woodhouse
Cc: Haojian Zhuang; Lei Wen; Axel Lin; linux-kernel; linux-mtd@lists.infradead.org
Subject: Re: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for samsung2GbX8

On Mon, Aug 16, 2010 at 9:05 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2010-08-16 at 20:55 +0800, Eric Miao wrote:
>> On Mon, Aug 16, 2010 at 8:49 PM, Haojian Zhuang <hzhuang1@marvell.com> wrote:
>> > http://lists.infradead.org/pipermail/linux-mtd/2010-July/subject.html
>> >
>> > They're re-posted in July. Please search the subjects in that page. They're totally 29 patches.
>> >
>> > By the way, David, what's the result of review on these patches? We already posted for several times.
>> >
>>
>> I've actually reviewed some of the patches and gave my Ack. For those
>> patches, I think they can be merged early.
>>
>> And overall, they look good. Yet 29 patch in a whole is still a bit too
>> much, would be good to see them logically be separated into several
>> patch series.
>
> You had some criticism of patch #1 in the sequence, and some questions.
>

So they need to be addressed. Lei, could you please come up with
an updated patch?

> I didn't look much harder than that, iirc... although looking back now
> it seems that the rest of your responses to the sequence were largely
> positive.
>
> Are you happy with the first patch, and if so shall I go ahead and
> import the whole sequence with your Acked-By:?
>

I'm generally OK, but still think it would be good to have another around
of review before they can be merged.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
