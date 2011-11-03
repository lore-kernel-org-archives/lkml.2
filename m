Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811Ab1KCPvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:51:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33374 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab1KCPvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:51:47 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1111031139150.2136-100000@iolanthe.rowland.org>
References: <CAOS58YNNx7XOGov19_hucAQYvw88F2YO+KoVpn8uD+COgJRbEw@mail.gmail.com>
	<Pine.LNX.4.44L0.1111031139150.2136-100000@iolanthe.rowland.org>
Date: Thu, 3 Nov 2011 08:51:46 -0700
X-Google-Sender-Auth: _BY9lz73Z5EMDyZpShBM-mWpZw8
Message-ID: <CAOS58YN1WByGtr1MNH12vbPVa-vyWa-LiHYgMWSJt1WbfK-vtw@mail.gmail.com>
Subject: Re: [PATCH 2/3] scsi: add hooks for host runtime power management
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lin Ming <ming.m.lin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 3, 2011 at 8:39 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> I don't know. I haven't really thought about it but as it's currently
>> designed, I don't think it'll be possible to avoid going through EH to
>> put ATA ports into suspend mode.
>
> Why not?

It's just how things are designed now.  There's no reason why it's
fundamentally impossible but going around that would require some
amount of hackery or preferably re-design.  Synchronization against
command processing, interrupts and all are built around EH.

Thanks.

-- 
tejun
