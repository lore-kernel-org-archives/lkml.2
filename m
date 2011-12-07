Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab1LGS3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:29:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55213 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab1LGS3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:29:39 -0500
Date: Wed, 7 Dec 2011 10:29:33 -0800
From: Tejun Heo <tj@kernel.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH v5 6/6] ata: add ata port runtime PM callbacks
Message-ID: <20111207182933.GC7610@google.com>
References: <1323048028-10421-1-git-send-email-ming.m.lin@intel.com>
 <1323048028-10421-7-git-send-email-ming.m.lin@intel.com>
 <CAF1ivSbr3b8vkgtA1Lzy-hKvm6MJ77bS5V2JkJF5+ybKCPObKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF1ivSbr3b8vkgtA1Lzy-hKvm6MJ77bS5V2JkJF5+ybKCPObKg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 04:42:09PM +0800, Lin Ming wrote:
> On Mon, Dec 5, 2011 at 9:20 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > Add ata port runtime suspend/resume/idle callbacks.
> > Set ->eh_noresume to skip the runtime PM calls on scsi host
> > in the error handler to avoid dead lock.
> 
> Hi Tejun & Alan,
> 
> How about this patch?

Looks good to me.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
