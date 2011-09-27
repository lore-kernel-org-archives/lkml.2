Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1I0MGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:06:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60016 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab1I0MGv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:06:51 -0400
MIME-Version: 1.0
Date: Tue, 27 Sep 2011 17:36:49 +0530
Message-ID: <CADDb1s0GF-+TLo00=SvQu=7qxY1DTK0VgSWHd9Vr0=q1k7S2PQ@mail.gmail.com>
Subject: USB HDD: Write Cache always shown as Disabled
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is Write Cache always shown as Disabled (Function:
sd_revalidate_disk(), File: drivers/scsi/sd.c)  – even though there is
write cache in USB HDD and which is enabled. This is verified by
enabling/disabling the cached using ‘hdparm’ and then checking the
performance.

I have few USB Hard disks – for all of them it is shown to be

Default Message:
“Assuming drive cache: Write Through”

If I change the condition in sd_read_cache_type(),
if (sdp->skip_ms_page_8){
        //      goto defaults;
}
Sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn’t
support DPO or FUA.


Can anyone provide any hint to this?  Or am I missing something in this?

Thanks & Regards,
Amit Sahrawat
