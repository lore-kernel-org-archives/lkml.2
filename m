Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750920Ab1IMJC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 05:02:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56186 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750712Ab1IMJC6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 05:02:58 -0400
Subject: Re: [RFC v2] arm: Add platform bus driver for virtio device
From: Pawel Moll <pawel.moll@arm.com>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: "Michael S.Tsirkin" <mst@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4E6E40EC.9040200@us.ibm.com>
References: <1315845956.3297.7.camel@hornet.cambridge.arm.com>
	 <1315846301-13892-1-git-send-email-pawel.moll@arm.com>
	 <4E6E40EC.9040200@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 09:58:42 +0100
Message-ID: <1315904322.3297.11.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 13 Sep 2011 08:58:43.0663 (UTC) FILETIME=[56F28DF0:01CC71F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 12:27 -0500, Anthony Liguori wrote:
> > This patch, based on virtio PCI driver, adds support for memory
> > mapped (platform) virtio  device. This should allow environments
> > like qemu to use virtio-based block&  network devices.
>
> Are you planning on sending patches to QEMU for this?  I think it makes 
> sense to start in QEMU with this effort and make a proper spec from 
> which you can write the driver against.

Even better :-) Peter Maydell (Linaro QEMU magician) agreed to do this
himself, once we reach some agreement regarding the interface.

Cheers!

Paweł

