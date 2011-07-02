Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1GBGIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 02:08:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47996 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1GBGIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 02:08:49 -0400
Date: Sat, 2 Jul 2011 08:08:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, rjw@sisk.pl, linux-usb@vger.kernel.org
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Message-ID: <20110702060846.GH23059@one.firstfloor.org>
References: <1309554818.2722.48.camel@mulgrave> <Pine.LNX.4.44L0.1107012200260.4273-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107012200260.4273-100000@netrider.rowland.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not able to reproduce it on a vanilla 3.0-rc5 system.  Can anybody
> give the exact sequence of steps you went through to trigger the bug?

Connect USB storage device with builtin fake CD rom. Wait for udisk
to mount it. Pull cable. udisk does umount. Oops.

I also got a log of the refcounting now if you want it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
