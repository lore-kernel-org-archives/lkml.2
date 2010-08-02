Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0HBQEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:04:52 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49114 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0HBQEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:04:51 -0400
Subject: Re: [RFC PATCH v8 00/16] Provide a zero-copy method on KVM
 virtio-net.
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
In-Reply-To: <20100801083113.GB16158@redhat.com>
References: <1280402088-5849-1-git-send-email-xiaohui.xin@intel.com>
	 <1280442682.9058.15.camel@localhost.localdomain>
	 <20100801083113.GB16158@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 09:04:35 -0700
Message-ID: <1280765075.22830.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michael,

On Sun, 2010-08-01 at 11:31 +0300, Michael S. Tsirkin wrote:
> I think we should explore the idea for the driver to fall back on data
> copy
> for small message sizes.
> The benefit of zero copy would then be CPU utilization on large
> messages.

Yes, we used to have 128 bytes for small copy in other driver. I saw
Xiaohui's patch here is using 64 bytes. I think we need to compare the
performance on different platform to decide what's the best for small
message size.

Thanks
Shirley

