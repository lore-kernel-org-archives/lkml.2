Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab0KOPRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:17:15 -0500
Received: from gate.crashing.org ([63.228.1.57]:34092 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab0KOPRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:17:14 -0500
Subject: Re: [PATCH v2] fsldma: add support to 36-bit physical address
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <AANLkTi=1nutREorMFY2VJyUYQD0SHfiSeskw-u22P+R-@mail.gmail.com>
Date: Mon, 15 Nov 2010 09:16:57 -0600
Cc: Li Yang <leoli@freescale.com>, dan.j.williams@intel.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3B38AD35-39A2-4A54-8109-65D6DE436227@kernel.crashing.org>
References: <1289477789-10651-1-git-send-email-leoli@freescale.com> <54AAF9B7-9533-45B8-9C49-A964203AF707@kernel.crashing.org> <AANLkTi=1nutREorMFY2VJyUYQD0SHfiSeskw-u22P+R-@mail.gmail.com>
To: Timur Tabi <timur.tabi@gmail.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 13, 2010, at 4:43 PM, Timur Tabi wrote:

> On Thu, Nov 11, 2010 at 5:56 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
> 
>> Is there any reason we shouldn't set DMA_BIT_MASK(64) since the DMA block programming model allows the address to be 64-bits?
> 
> Can you explain that?  The DMA registers only have room for 36 bits
> for the physical address.

The programming model (if you look at the free-space in the registers and data structures) supports a 64-bit address.  I'm trying to avoid changing the driver in the future if we have >36-bit.  However this is such a minor worry that I'll stop and just ack the patch as is.

- k