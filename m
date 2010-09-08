Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0IHOCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:02:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36305 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0IHOCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:02:38 -0400
Date: Wed, 8 Sep 2010 16:02:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, axboe@kernel.dk, tiwai@suse.de,
        James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH] SYSFS: Allow boot time switching between deprecated and
 modern sysfs layout
Message-ID: <20100908160235.61ae1200@basil.nowhere.org>
In-Reply-To: <20100908135530.GA2978@kroah.com>
References: <1283951991-16202-1-git-send-email-andi@firstfloor.org>
	<20100908135530.GA2978@kroah.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010 06:55:30 -0700
Greg KH <greg@kroah.com> wrote:

> But, Kay and I just changed the logic in the kernel in this area,
> getting rid of the CONFIG_SYSFS_DEPRECATED_V2 option entirely, to try
> to make the code path smaller, only offering the "old" mode for block
> devices, to keep kernels booting on userspace instances like what you
> have.

That will likely break my user space, it relies on the old style
net set up (opensuse 10.0) for network configuration. 
That was the main reason I did this patch.


> 
> So, could you respin this patch against the linux-next tree which has
> Kay's patch in it?  Or, if it's easier, I've attached the patch below.

I can test your patch first, but to be honest I doubt it'll work on the
10.0 roots.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
