Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab0EKSQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:16:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047Ab0EKSQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:16:57 -0400
Date: Tue, 11 May 2010 21:12:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, gleb@redhat.com
Subject: virtio: power management
Message-ID: <20100511181221.GA9361@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone looked at power management with virtio?
virtio-pci has callbacks to save/restore pci config
on suspend/resume, but it seems that more action,
such as restoring queue state, would be needed
for e.g. suspend to disk to work.

Rusty, any hints on the code in virtio-pci
that deals with suspend? Is it incomplete?

Thanks,

-- 
MST
