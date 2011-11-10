Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935502Ab1KJQDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:03:10 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44396 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932857Ab1KJQDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:03:07 -0500
MIME-Version: 1.0
In-Reply-To: <20111110153036.GC27258@google.com>
References: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com> <20111110153036.GC27258@google.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 10 Nov 2011 17:02:41 +0100
Message-ID: <CAPXgP12-CxDBa0cHtM+ejczR4131tnvq3N0WKQ5egt4hb31kPg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] ata port runtime power management support
To: Tejun Heo <tj@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>,
        Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 16:30, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Nov 10, 2011 at 02:22:42PM +0800, Lin Ming wrote:

>> v2 changes it to:
>>
>>         /sys/devices/pci0000:00/0000:00:1f.2    (ahci controller)
>>         |-- ata1                                (ata port)
>>             |-- host0                           (scsi host)
>>                 |-- target0:0:0                 (scsi target)
>>                     |-- 0:0:0:0                 (disk)
>>
>> So ata port runtime PM will happen as:

>> This is much cleaner and natural.
>
> Yeah, I really like this approach.  Nicely done.  I *think* the
> hierarchy change should be okay but cc'ing Kay just in case.

Looks good to me. All non-broken users of sysfs should be fine and
cope with changes like this without any problem.

Kay
