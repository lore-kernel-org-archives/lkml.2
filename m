Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030501Ab2HHRzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:55:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59736 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756Ab2HHRzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:55:15 -0400
MIME-Version: 1.0
In-Reply-To: <1340375470-13097-2-git-send-email-sjur.brandeland@stericsson.com>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
	<1340375470-13097-2-git-send-email-sjur.brandeland@stericsson.com>
Date: Wed, 8 Aug 2012 19:55:13 +0200
Message-ID: <CAJK669adq29ipOCTOyXNoqW=gF4pOJZZgZ_0tnjm75JY22Gvag@mail.gmail.com>
Subject: Re: [RFC 1/4] remoteproc: Bugfix assign device address to carveout (noiommu)
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> Carveout did not set device address when IOMMU is not supported.
> Fix this by assigning dma address to device address to carveout
> if IOMMU is not supported.

I realize that we have the same issue with the virtio rings.
Are there any way we can assign the device address of the virtio rings
to the resource table in shared memory? Or do we have to calculate the
virtio ring addresses based on number rings and the number of elements
in the ring?

Regards,
Sjur
