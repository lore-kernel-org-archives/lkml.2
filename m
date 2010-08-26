Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0HZNA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:00:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47151 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab0HZNAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:00:54 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: "Kanigeri, Hari" <h-kanigeri2@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Date: Thu, 26 Aug 2010 08:00:47 -0500
Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Topic: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Index: ActFBhy+gMEmxOz1RKKxvCu/1o1hGQAFug0r
Message-ID: <496565EC904933469F292DDA3F1663E602F10ED4B2@dlee06.ent.ti.com>
References: <1277943660-4112-1-git-send-email-x0095840@ti.com>
	<1277943660-4112-2-git-send-email-x0095840@ti.com>
	<1277943660-4112-3-git-send-email-x0095840@ti.com>
	<1277943660-4112-4-git-send-email-x0095840@ti.com>
	<1277943660-4112-5-git-send-email-x0095840@ti.com>
	<1277943660-4112-6-git-send-email-x0095840@ti.com>
	<1277943660-4112-7-git-send-email-x0095840@ti.com>
	<1277943660-4112-8-git-send-email-x0095840@ti.com>
	<1277943660-4112-9-git-send-email-x0095840@ti.com>
	<8F7AF80515AF0D4D93307E594F3CB40E4CAD34D5@dlee03.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CBDD3ADE@dlee06.ent.ti.com>
	<8F7AF80515AF0D4D93307E594F3CB40E4CAD39F6@dlee03.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CBDD3BB2@dlee06.ent.ti.com>
	<AANLkTimENxUjUWJQSZ1dmdkX_9hQ0pjat-kyR9oNjVxf@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3883@dlee06.ent.ti.com>
	<AANLkTi=NuPu6bvv6KF7sXRp02bvfz7oRkG1SG1PstA-H@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA397F@dlee06.ent.ti.com>
	<AANLkTinaJ=xn_CAJznVtMcA0nwK_-gbo05OQKM7PuoYA@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3995@dlee06.ent.ti.com>
	<AANLkTinjMujus-28DcLzZ+16GAGpLohwhPhuTi5uKhB8@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA39BA@dlee06.ent.ti.com>
	<AANLkTikQCTtwOkAmt3PZrOkxi=VzJtfNKGsH=YXawt9t@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3AED@dlee06.ent.ti.com>
	<AANLkTi=4YYvyHdL=F_FYQ4e5v-+K3RMZFngdfuKPQ-4L@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3D20@dlee06.ent.ti.com>
	<AANLkTi=VRROWWZ4x-znXshz9KWNZAaizVFt=M92D3ByW@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F142E143@dlee06.ent.ti.com>,<AANLkTiksJpU5=NtBMDmUzVfHNsGe7REtananNDL10FX_@mail.gmail.com>
In-Reply-To: <AANLkTiksJpU5=NtBMDmUzVfHNsGe7REtananNDL10FX_@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>________________________________________
>From: Felipe Contreras [felipe.contreras@gmail.com]
>Sent: Thursday, August 26, 2010 5:04 AM
>To: Guzman Lugo, Fernando
>Cc: Kanigeri, Hari; linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; ohad@wizery.com; hiroshi.doyu@nokia.com; ameya.palande@nokia.com; >felipe.contreras@nokia.com
>Subject: Re: [PATCH 8/9] dspbridge: add map support for big buffers
>
>On Wed, Aug 25, 2010 at 10:42 PM, Guzman Lugo, Fernando
><fernando.lugo@ti.com> wrote:
>>> On Wed, Aug 25, 2010 at 7:00 PM, Guzman Lugo, Fernando
>>> <fernando.lugo@ti.com> wrote:
>>> >> Or the whole iovmm.c can be copied and just remove the mapping.
>>> >
>>> > That is the migration patches do, remove custom bridge
>>> mapping and use
>>> > iovmm module instead.
>>>
>>> You didn't get me; copy the iovmm.c code into dmm.c, and
>>> remove the mapping.
>>
>> It sounds like double work, changing the dmm.c which will disappear.
>
>But in the meantime the bug is still there, and there's no timeline
>when it will disappear.

I think you are talking about the issue when there are a lot of reservations and
unreservations of big buffer and the memory is getting fragmented and it is not
possible to allocate more big buffers.

if so, I don't think it is a bug. The thing is because of the algorithm used for 
reserve memory is optimized to satisfy the memory requested as soon as possible,
so this algorithm is good where there are too much reservation of memory and
for small buffers, because the algorithm get rid of big free chucks of memory
soon.

so that issue, can be fixed just chaning the algorithm without changing the array implementation
in dmm.c.

>
>> Also I think what you want is only the change from array to
>> Linked list.
>
>That's what I said.
>
>> Otherwise copying iovmm.c into dmm.c and adapting
>> To how dspbridge is at this momment it will need too much changes,
>
>Yeah, I just said that it was possible.
>
>> It is better to think like: take memory reservation (linked list)
>> Implementation from iovmm and map it to dmm.c.
>
>I think so too.
>
>> But I don't see the point of doing that, if dmm.c is about to
>> Dissapear.
>
>When exactly?

with iommu migration patches, hopefully next week.


Regards,
Fernando.

>
>--
>Felipe Contreras
