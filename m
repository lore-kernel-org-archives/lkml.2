Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1LAO2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:28:07 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63316 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab1LAO2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:28:04 -0500
MIME-Version: 1.0
In-Reply-To: <4ED78D15.1000306@pobox.com>
References: <1322442950-16268-1-git-send-email-ming.m.lin@intel.com>
	<CAF1ivSa8d-VNbOmO9UyG-J3TKDmfuuX9pWEtT_7a7OcCC-0Uow@mail.gmail.com>
	<4ED78D15.1000306@pobox.com>
Date: Thu, 1 Dec 2011 22:28:02 +0800
X-Google-Sender-Auth: 9HDFilR1CRO0h63dJTZ0hxt_cxI
Message-ID: <CAF1ivSZb6dLHa_QkF10GuqHFaeuWVPAzZJCbq03La9jVB1xs-A@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] ata port runtime power management support
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 10:20 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
> On 12/01/2011 09:09 AM, Lin Ming wrote:
>>
>> On Mon, Nov 28, 2011 at 9:15 AM, Lin Ming<ming.m.lin@intel.com>  wrote:
>>>
>>> Hi all,
>>>
>>> This is the v4 patches to add ata port runtime pm support.
>>> Applied on top of v3.2-rc2.
>>>
>>> Jeff, any comment on the ata patches?
>>> James, any comment on the scsi patches?
>>
>>
>> Ping ...
>>
>> Which git tree should these patches go into? ATA or SCSI?
>>
>> Lin Ming (6):
>>     ata: make ata port as parent device of scsi host
>>     [SCSI] add flag to skip the runtime PM calls on the host
>>     [SCSI] check runtime PM status in system PM
>>     [SCSI] sd: check runtime PM status in sd_shutdown
>>     ata: add ata port system PM callbacks
>>     ata: add ata port runtime PM callbacks
>>
>>  drivers/ata/libata-core.c      |  154
>> ++++++++++++++++++++++------------------
>>  drivers/ata/libata-scsi.c      |    3 +-
>>  drivers/ata/libata-transport.c |    5 ++
>>  drivers/ata/libata.h           |    1 +
>>  drivers/scsi/scsi_error.c      |    5 +-
>>  drivers/scsi/scsi_pm.c         |   16 ++++-
>>  drivers/scsi/sd.c              |    5 ++
>>  include/scsi/scsi_host.h       |    3 +
>>  8 files changed, 118 insertions(+), 74 deletions(-)
>
>
> I think ATA, with SCSI acks...

OK.

Could you help to review the ATA patches?

Thanks.

>
>        Jeff
