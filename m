Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab1JMQuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:50:03 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50629 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753553Ab1JMQuB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:50:01 -0400
Subject: Re: [PATCH v3] virtio: Add platform bus driver for memory mapped
 virtio device
From: Pawel Moll <pawel.moll@arm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <aliguori@us.ibm.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
In-Reply-To: <1317919843-8343-1-git-send-email-pawel.moll@arm.com>
References: <1317841030-17758-1-git-send-email-pawel.moll@arm.com>
	 <1317919843-8343-1-git-send-email-pawel.moll@arm.com>
Date: Thu, 13 Oct 2011 17:49:54 +0100
Message-ID: <1318524594.3216.119.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 13 Oct 2011 16:49:55.0550 (UTC) FILETIME=[22B2A7E0:01CC89C8]
X-MC-Unique: 111101317495701601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

On Thu, 2011-10-06 at 17:50 +0100, Pawel Moll wrote:
> This patch, based on virtio PCI driver, adds support for memory
> mapped (platform) virtio device. This should allow environments
> like qemu to use virtio-based block & network devices even on
> platforms without PCI support.
> 
> One can define and register a platform device which resources
> will describe memory mapped control registers and "mailbox"
> interrupt. Such device can be also instantiated using the Device
> Tree node with compatible property equal "virtio,mmio".
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Anthony Liguori <aliguori@us.ibm.com>
> Cc: Michael S.Tsirkin <mst@redhat.com>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

Does the silence mean that everyone is happy about the code and the
spec? ;-) Does it look good enough for the imminent 3.2 merge window?

Cheers!

Pawel


