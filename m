Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2LDOH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:07:57 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46300 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab2LDOHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:07:38 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-ac-50be03a84e5e
Message-id: <50BE03A6.6010504@samsung.com>
Date: Tue, 04 Dec 2012 15:07:34 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Chris Ball <cjb@laptop.org>
Cc: Kevin Liu <keyuan.liu@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, lrg@ti.com,
        Philip Rakity <prakity@nvidia.com>
Subject: Re: FW: [PATCH v2] mmc: sdhci: apply voltage range check only for
 non-fixed regulators
References: <25B60CDC2F704E4E9D88FFD52780CB4C060FBEA29A@SC-VEXCH1.marvell.com>
 <CADz5_gLC=z_VYrNq8q3dU7L6im7shSz-Sn6Tzym2mRZONwpgUg@mail.gmail.com>
 <50AB34E2.1010206@samsung.com>
 <CADz5_gKdUq8bjuMr1=yo65ysHzLNvKnrfVuSpLk-Q6ek-TWpNA@mail.gmail.com>
 <50AB587F.3040405@samsung.com>
 <CADz5_gJ1hV3n-4BPgBNT9LDp2-E=vNNzMGx=_9PmzT0RJ9+TsA@mail.gmail.com>
 <50AB81C8.4090300@samsung.com>
 <CADz5_gL3uHbvhb2ccp03=9P88u1Catxe9+Xffs3KmJsZGWmWvA@mail.gmail.com>
 <50AB9B90.1030404@samsung.com> <87hao7f344.fsf@octavius.laptop.org>
In-reply-to: <87hao7f344.fsf@octavius.laptop.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t/xq7ormPcFGPzZImlxedccNosj//sZ
	HZg8Pm+SC2CM4rJJSc3JLEst0rdL4MrY39fDVLCbo2Lhg/vMDYy32boYOTkkBEwkJuzbzARh
	i0lcuLceKM7FISSwlFFiwo4tTBBOM5PE78M7mUGqeAW0JE4snATWzSKgKvHs+jxGEJtNwFCi
	620XWFxUwFdi2q9rTBD1ghI/Jt9jAbFFBOQl7vd9A9vALPCAUeLf8iXsIAlhgUSJyy92Q62e
	zCJxduo1sEmcQFOnXNsMtplZwEziUcs6KFteYvOat8wTGAVmIVkyC0nZLCRlCxiZVzGKppYm
	FxQnpeca6hUn5haX5qXrJefnbmKEBOSXHYyLj1kdYhTgYFTi4Q14uydAiDWxrLgy9xCjBAez
	kgivwoe9AUK8KYmVValF+fFFpTmpxYcYmTg4pRoYl3822POANcG/9viOFrcXvyr4r6ifijl/
	axvXpo+/J09dyqTwu2mZm35iem3BpbNHfKU9n6re4GHz0DL57yn7WdEmN/F2xqpAs65FjecL
	QrlqxWIZ+VSfWcq+SpuYdeLMqj71Q8vn1O04eSvA+8M2nZ7ZDMvj7tS2l8aoXpb5r+qoKjKT
	o/O6EktxRqKhFnNRcSIAB/+KjSYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/30/2012 5:48 PM, Chris Ball wrote:
> On Tue, Nov 20 2012, Marek Szyprowski wrote:
> > The problem with dummy regulator is the fact that it can be enabled only
> > globally for all devices in the system. I think that the best solution
> > would be to introduce regulator_can_change_voltage() as Mark suggested.
> > I will post patches soon.
>
> Does this mean that I shouldn't merge either yours or Kevin's patch for
> 3.8, while we wait for this?  Any ETA on it?

I've just posted an updated patches to solve those issues. I'm sorry for the
delay as I was terribly busy with other stuff. Kevin's patch is still
required and it should stay in the tree because it indeed fixes other, in
some cases related issues.

However my earlier patch "mmc: sdhci: apply voltage range check only for
non-fixed regulators" can be replaced with the new patches from the
"[PATCH v2 0/3] Fix fixed regulators support" thread posted a few minutes
ago (those patches are based on mmc-next branch).

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


