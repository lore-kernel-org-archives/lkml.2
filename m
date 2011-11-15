Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1KOKcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 05:32:08 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55579 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab1KOKcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 05:32:07 -0500
Subject: Re: [PATCH] virtio: add HAS_IOMEM dependency to MMIO platform bus
 driver
From: Pawel Moll <pawel.moll@arm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <1321348404-3549-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1321348404-3549-1-git-send-email-heiko.carstens@de.ibm.com>
Date: Tue, 15 Nov 2011 10:31:58 +0000
Message-ID: <1321353118.3137.92.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 15 Nov 2011 10:31:59.0279 (UTC) FILETIME=[CE380BF0:01CCA381]
X-MC-Unique: 111111510320301101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 09:13 +0000, Heiko Carstens wrote:
> Fix this compile error on s390:
> 
>   CC [M]  drivers/virtio/virtio_mmio.o
> drivers/virtio/virtio_mmio.c: In function 'vm_get_features':
> drivers/virtio/virtio_mmio.c:107:2: error: implicit declaration of function 'writel'

One learns something new every day :-O

Thanks and apologies for inconvenience!

> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Pawel Moll <pawel.moll@arm.com>

Cheers!

Pawel


