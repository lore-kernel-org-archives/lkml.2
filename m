Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab0ELPUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:20:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:25648 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab0ELPUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=WdHpm1SiMmMBDb0VXYB8fGK7JKxMYfsdQDGPsziHQMHcfO0Ge0nzTGcP3/jIZHogDa
         zbdFFxDDUIKDJirv57zzJqTvzQfpmz1V/4CuiLUAOGO6HCHFQzUmp4iJwnaeIL1Il8nM
         4kCfeCKRyrtgpSpUR6MIV/yCSgDw/q5iFa1aQ=
MIME-Version: 1.0
Date: Wed, 12 May 2010 17:20:22 +0200
Message-ID: <AANLkTiniV7MElKMWOuxbyaVWe__X0BmUvIeIuOmq9u1J@mail.gmail.com>
Subject: diskstats - sectors written, what does it mean for mmc-cards?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a small arm based server running enterly from an mmc-card.
To get some glue how much the mmc-card is written to, I had a look at
diskstat, which, after 9 days uptime, looks like:

 254    0 mmcblk0 87047 34549 2851200 3081695 483009 484000 7736450
30472168 0 5847544 51650
 254    1 mmcblk0p1 63356 2037674 920699 7365592
 254    2 mmcblk0p2 58214 813270 46364 370858

So, to mmcblk0 7736450 sectors have been written, and the kernel had
to wait 5,7h for the writes to complete.
But how can I find out how large a sector is?

If I assume its 512 bytes, that would mean 3,8gb have been written to
that card in the last few days, which seems quite a lot.

Thanks, Clemens
