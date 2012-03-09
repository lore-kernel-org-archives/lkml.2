Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311Ab2CIARv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:17:51 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49153 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759274Ab2CIARh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:17:37 -0500
X-AuditID: cbfee612-b7c09ae0000024ca-47-4f594c1fd658
Date: Fri, 09 Mar 2012 00:17:35 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH 0/3] power: max17042_battery: Add DT bindings
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: "DirkBrandewie<dirk.brandewie"@gmail.com, linux-kernel@vger.kernel.org
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120309000949480@myungjoo.ham
Msgkey: 20120309000949480@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120309000949480@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <33272430.5261331252254898.JavaMail.weblogic@epml04>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q290Huk0026375

Dear Karol Lewandowski,

I've been confused this patchset with Dirk Brandewie's MAX17042 patchset; I though this was a follow-up version of Dirk's, which I think already acked by me.

Anyway, the patches themselves look fine.

However, have you checked the compatibility (mergability?) with the recent MAX17042 patches of Dirk Brandewie? I'm not sure about the merge status of Dirk's patchset, but, I think you need to consider his patches as they massively reshaped the device driver.

Other than that, the patches look fine. (If that issue is already considered, regard this as an Acked-by.)

Thank you.


Cheers!
MyungJoo.

------- Original Message -------
Sender : Karol Lewandowski<k.lewandowsk@samsung.com> Junior Software Engineer/SPRC-Linux (MSD)/»ï¼ºÀüÀÚ
Date : 2012-03-08 19:32 (GMT+09:00)
Title : Re: [PATCH 0/3] power: max17042_battery: Add DT bindings

Dear MyungJoo Ham,

Could you take a look at patchset I've sent? It's needed to make use of
max17042 driver on device tree-enabled platforms.

Regards,
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform

On 22.02.2012 19:06, Karol Lewandowski wrote:

> Hi,
> 
> This series of patches adds bindings to max17042_battery driver making
> it possible to instantiate it from device tree description.
> 
> First, convience patch, simply replaces kzalloc with devm_kzalloc
> where possible.
> 
> Second, most intrusive patch adds variables orginally found only in
> platform data to max17042_chip structure.  I decided it to do it that
> way rather than allocating new platform data and then populating it
> from device tree description.
> 
> Last patch adds DT bindings itself.
> 
> I would be grateful for any comments and I will be more than happy to
> rework this patchset if needed.
> 
> 
> Karol Lewandowski (3):
>   max17042_battery: Use devm_kzalloc() where applicable
>   max17042_battery: Preserve properties outside of platform data
>   max17042_battery: Make it possible to instantiate driver from DT
> 
>  .../bindings/power_supply/max17042_battery.txt     |   18 +++++
>  drivers/power/max17042_battery.c                   |   77 ++++++++++++++++----
>  2 files changed, 79 insertions(+), 16 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/power_supply/max17042_battery.txt
> 






--
MyungJoo Ham (ÇÔ¸íÁÖ), PHD
System S/W Lab, S/W Platform Team, Software Center
Samsung Electronics
Cell: +82-10-6714-2858ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
