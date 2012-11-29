Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2K2ULL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:11:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:31208 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab2K2ULK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:11:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,186,1355126400"; 
   d="scan'208";a="224432365"
From: Andi Kleen <andi@firstfloor.org>
To: Joseph Parmelee <jparmele@wildbear.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Binutils test suite freezes kernel
References: <alpine.LNX.2.00.1211071634440.1754@bruno>
Date: Thu, 29 Nov 2012 12:11:09 -0800
In-Reply-To: <alpine.LNX.2.00.1211071634440.1754@bruno> (Joseph Parmelee's
	message of "Wed, 7 Nov 2012 17:56:19 -0600 (CST)")
Message-ID: <m2k3t4f9uq.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph Parmelee <jparmele@wildbear.com> writes:

> Greetings:
>
> The gas test suite in recent binutils snapshots from
> ftp://sourceware.org/pub/binutils/snapshots/ consistently freezes my i386
> custom-built kernels.  This may be a kernel configuration problem but if so
> it has manifested only recently.  I have been building kernels since 1995
> and this is the first instance I have seen where the kernel is brought down
> by a non-privileged user space process.  AIUI this should be impossible
> regardless of what that process is doing.  The problem affects all kernels
> between 3.6.2 and 3.6.6.  These are merely the kernels were I have seen the
> problem; it may well affect other kernels.

A common cause of this would be running out of memory.
While this should eventually resolve itself it may take a long time
and the system may appear frozen.

I would rerun with an appropiate ulimit setting.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
