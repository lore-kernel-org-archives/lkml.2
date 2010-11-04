Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0KDKBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:01:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59373 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab0KDKBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:01:05 -0400
Date: Thu, 4 Nov 2010 11:00:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [RFC 2/4]x86: allocate 32 tlb_invalidate_interrupt handlers
Message-ID: <20101104100058.GC32383@basil.fritz.box>
References: <1288766661.23014.115.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288766661.23014.115.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 02:44:21PM +0800, Shaohua Li wrote:
> Add up to 32 invalidate_interrupt handler. How many handlers are
> added depends on NUM_INVALIDATE_TLB_VECTORS. So if NUM_INVALIDATE_TLB_VECTORS
> is smaller than 32, we don't waste icache.

Just a small nit on the description: icache doesn't really
matter for init code, it's just about binary size on disk.

The patch looks ok.

-Andi
