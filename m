Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab2CIRcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:32:41 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51628 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759Ab2CIRck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:32:40 -0500
Date: Fri, 09 Mar 2012 18:32:37 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 0/3] power: max17042_battery: Add DT bindings
In-reply-to: <33272430.5261331252254898.JavaMail.weblogic@epml04>
To: myungjoo.ham@samsung.com
Cc: DirkBrandewie <dirk.brandewie@gmail.com>, linux-kernel@vger.kernel.org
Message-id: <4F5A3EB5.5040405@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=EUC-KR
Content-transfer-encoding: 8BIT
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <33272430.5261331252254898.JavaMail.weblogic@epml04>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear MungJoo,

I wasn't aware of Dirk's patchset and thus, I didn't ever try to make my
patches compatible with it.

I've found hopefully correct patchset[1] via google - it's mailing list
posting without any feedback...  I've checked linux-next and it clearly
hasn't been merged.

I'm happy to rework my patch but I would like to ask you about specific
tree I should base on.  Is this patchset in some subsystem-specific
(power?) tree? Other?

[1] https://lkml.org/lkml/2012/1/24/237

Regards,
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform

On 09.03.2012 01:16, 함명주 wrote:

> Dear Karol Lewandowski,
> 
> I've been confused this patchset with Dirk Brandewie's MAX17042 patchset; I though this was a follow-up version of Dirk's, which I think already acked by me.
> 
> Anyway, the patches themselves look fine.
> 
> However, have you checked the compatibility (mergability?) with the recent MAX17042 patches of Dirk Brandewie? I'm not sure about the merge status of Dirk's patchset, but, I think you need to consider his patches as they massively reshaped the device driver.
> 
> Other than that, the patches look fine. (If that issue is already considered, regard this as an Acked-by.)
> 
> Thank you.
> 
> 
> Cheers!
> MyungJoo.
> 
> ------- Original Message -------
> Sender : Karol Lewandowski<k.lewandowsk@samsung.com> Junior Software Engineer/SPRC-Linux (MSD)/삼성전자
> Date : 2012-03-08 19:32 (GMT+09:00)
> Title : Re: [PATCH 0/3] power: max17042_battery: Add DT bindings
> 
> Dear MyungJoo Ham,
> 
> Could you take a look at patchset I've sent? It's needed to make use of
> max17042 driver on device tree-enabled platforms.
> 
> Regards,




