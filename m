Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab2BBR1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:27:07 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61833 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab2BBR1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:27:03 -0500
MIME-Version: 1.0
In-Reply-To: <1328202004.18641.28.camel@joe2Laptop>
References: <1328191660-2037-1-git-send-email-standby24x7@gmail.com>
	<1328202004.18641.28.camel@joe2Laptop>
Date: Fri, 3 Feb 2012 02:27:02 +0900
Message-ID: <CALLJCT2reS9VHHZ1ejNpFiQz-mN17s7jiyR0d_0MQnhxuDLHtA@mail.gmail.com>
Subject: Re: [PATCH] [trivial] pm8001: Fix typo in pm8001_hwi.c
From: Masanari Iida <standby24x7@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: jack_wang@usish.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 2:00 AM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2012-02-02 at 23:07 +0900, Masanari Iida wrote:
>> Correct typo "deviece" to "device" in
>> drivers/scsi/pm8001/pm8001_hwi.c
> []
>> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> []
>> @@ -3532,7 +3532,7 @@ static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
>> []
>> -                     pm8001_printk("unresgister the deviece\n"));
>> +                     pm8001_printk("unresgister the device\n"));
>
> another typo of unregister
>
Thanks
I just sent v2 patch to the list.

Masanari
