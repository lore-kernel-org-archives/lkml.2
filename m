Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1GRSAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 14:00:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53553 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1GRSAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 14:00:08 -0400
Date: Mon, 18 Jul 2011 20:00:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Andi Kleen <andi@firstfloor.org>,
        axboe@kernel.dk,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Dave Jones <davej@redhat.com>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Message-ID: <20110718180007.GE8006@one.firstfloor.org>
References: <20110702181146.GM23059@one.firstfloor.org> <Pine.LNX.4.44L0.1107021544550.16190-100000@netrider.rowland.org> <CAA9_cmcPhkA5myxeR5aJWBQ=-C3VuG_M9Appp5WyrLoU5fnw2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmcPhkA5myxeR5aJWBQ=-C3VuG_M9Appp5WyrLoU5fnw2w@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch seems to resolve the block/scsi null-ptr de-references in
> our libsas/isci environment, we have yet to try James' alternative
> [1].  Do we potentially need both?
> 
> Commit 86cbfb56 moved scsi_free_queue to __scsi_remove_device() but it
> seems only the "sdev->request_queue->queuedata = NULL" needed to be
> moved?
> 
> The conversation appeared to be awaiting test results...

Alan's patch worked for me too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
