Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680Ab2HIUfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 16:35:11 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35384 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab2HIUfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:35:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAK=WgbbK+p3BGcohzgoY9Y57xD1kYHyGDu-FXFXaLFoA9xz7ow@mail.gmail.com>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
	<1340375470-13097-2-git-send-email-sjur.brandeland@stericsson.com>
	<CAJK669adq29ipOCTOyXNoqW=gF4pOJZZgZ_0tnjm75JY22Gvag@mail.gmail.com>
	<CAK=WgbbK+p3BGcohzgoY9Y57xD1kYHyGDu-FXFXaLFoA9xz7ow@mail.gmail.com>
Date: Thu, 9 Aug 2012 22:35:07 +0200
Message-ID: <CAJK669bpog-nNCZ5F5dGWqrS8p5ibob_5eq51r8+6NNimYgpGQ@mail.gmail.com>
Subject: Re: [RFC 1/4] remoteproc: Bugfix assign device address to carveout (noiommu)
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,
>> I realize that we have the same issue with the virtio rings.
>> Are there any way we can assign the device address of the virtio rings
>> to the resource table in shared memory?
>
> It's a gap we have today, but it should definitely be fixed.

Ok, good.

Any thoughts on how to go about to fix this?
It does look a more comlex to solve than the carveout,
as the vrings are allocated in the first pass of fw parsing,
but fw is loaded to device memory in the second pass.

Regards,
Sjur
