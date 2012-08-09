Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab2HITzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:55:16 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48969 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473Ab2HITzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:55:13 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.151.238]
In-Reply-To: <CAJK669adq29ipOCTOyXNoqW=gF4pOJZZgZ_0tnjm75JY22Gvag@mail.gmail.com>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
 <1340375470-13097-2-git-send-email-sjur.brandeland@stericsson.com> <CAJK669adq29ipOCTOyXNoqW=gF4pOJZZgZ_0tnjm75JY22Gvag@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 9 Aug 2012 22:54:53 +0300
Message-ID: <CAK=WgbbK+p3BGcohzgoY9Y57xD1kYHyGDu-FXFXaLFoA9xz7ow@mail.gmail.com>
Subject: Re: [RFC 1/4] remoteproc: Bugfix assign device address to carveout (noiommu)
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Wed, Aug 8, 2012 at 7:55 PM, Sjur Brændeland <sjurbren@gmail.com> wrote:
> I realize that we have the same issue with the virtio rings.
> Are there any way we can assign the device address of the virtio rings
> to the resource table in shared memory?

It's a gap we have today, but it should definitely be fixed.

> Or do we have to calculate the
> virtio ring addresses based on number rings and the number of elements
> in the ring?

No, that's not the long term intention. It can be used as an interim
solution, but I expect we do fix this and start supporting dynamic
assignments of the vrings locations at some point.

Thanks,
Ohad.
