Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470Ab0HJWC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:02:56 -0400
Received: from 8bytes.org ([88.198.83.132]:37880 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933439Ab0HJWCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:02:51 -0400
Date: Wed, 11 Aug 2010 00:02:50 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.35] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40  BUG:
	unable to handle kernel NULL pointer dereference at 0000000000000198
Message-ID: <20100810220250.GV23755@8bytes.org>
References: <1154489525.20100810164850@eikelenboom.it> <20100810162606.GQ23755@8bytes.org> <419601760.20100810185745@eikelenboom.it> <20100810180122.GR23755@8bytes.org> <1609756756.20100810200514@eikelenboom.it> <20100810202839.GS23755@8bytes.org> <618241473.20100810223635@eikelenboom.it> <20100810204721.GT23755@8bytes.org> <1498209076.20100810233659@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498209076.20100810233659@eikelenboom.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok,

On Tue, Aug 10, 2010 at 11:36:59PM +0200, Sander Eikelenboom wrote:
> It boots now, dmesg attached.

AMD-Vi: Event logged [IO_PAGE_FAULT device=0a:00.0 domain=0x0000 address=0x0000000000001080 flags=0x0070]

So it indeed uses 0a:00.0 as the device id. Thats weird but states that
the BIOS is actually ok. I need to fix that in the driver.

Thanks,

	Joerg

