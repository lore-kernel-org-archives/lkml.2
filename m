Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab1KBPRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:17:05 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63934 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab1KBPRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:17:01 -0400
Date: Wed, 2 Nov 2011 08:17:11 -0700
From: Tejun Heo <tj@kernel.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@Parallels.com>,
        Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 0/3] ata port runtime power management support
Message-ID: <20111102151711.GB12543@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1320214900-2112-1-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320214900-2112-1-git-send-email-ming.m.lin@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 02, 2011 at 02:21:37PM +0800, Lin Ming wrote:
> These 3 patches add ata port runtime pm support, which is done through scsi layer.
> scsi host runtime pm mechanism is already there(scsi_pm.c).
> These patches add hooks for ata port.
> 
> Lin Ming (3):
>       scsi: fix potential dead lock for host runtime pm
>       scsi: add hooks for host runtime power management
>       ata: implement ata port runtime pm hooks

Hmmm.... Some questions.

* How much does this add on top of hardware timed auto spindown and
  dynamic link power management?

* Do the added benefits justify yet another runtime powersaving
  mechanism?

* Any way we can tie the other stuff with overall runtime PM?

Thanks.

-- 
tejun
