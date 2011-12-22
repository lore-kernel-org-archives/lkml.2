Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab1LVBTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:19:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36344 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab1LVBTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:19:08 -0500
MIME-Version: 1.0
In-Reply-To: <20111212134937.GE2547@sgi.com>
References: <CAPXgP10gRKAgo1ExkvLyNqceKpGujcov90umPQCRiNJ=qTwU_A@mail.gmail.com>
 <20111212124538.GC2547@sgi.com> <CAPXgP10SU77-S9kerb5UwhNB3yAgg_6zAmeLpDpGFTq+yTbY=w@mail.gmail.com>
 <20111212134937.GE2547@sgi.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 22 Dec 2011 02:18:47 +0100
Message-ID: <CAPXgP11EBq-b1n7GS4qwS=Kco8yKsy2cRXJ7=iWO=z_GeJN9og@mail.gmail.com>
Subject: Re: question about link_mem_sections()
To: Robin Holt <holt@sgi.com>
Cc: Greg Kroah-Hartmann <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 14:49, Robin Holt <holt@sgi.com> wrote:
> On Mon, Dec 12, 2011 at 02:11:28PM +0100, Kay Sievers wrote:

> If you do decide to rework that logic, we can retest for the next couple
> months.  We do not normally have a 16TB test machine lying around (IIRC,
> the memory in something like that costs a couple million dollars), but we
> do fortunately have one right now until the latter part of next quarter.

The rework of the sys_devices with the goal to finally removal of all
sysdev stuff is in Greg's tree now:
  http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=shortlog;h=refs/heads/driver-core-next
It will be available in linux-next.

The hinted search moved from the 'kobject' to the 'bus' as:
  dev = subsys_find_device_by_id(&memory_subsys, block_id, hintdev);

Would be nice if you can eventually give it a try, on the big box, to
make sure we didn't break anything.

Thanks a lot,
Kay
