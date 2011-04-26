Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab1DZVtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:49:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61550 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428Ab1DZVti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:49:38 -0400
From: Martin <marogge@onlinehome.de>
To: "vger.kernel.org, " <linux-kernel@vger.kernel.org>
Subject: i915 drm GPU hung - potential regression on 2.6.38
Date: Tue, 26 Apr 2011 23:49:36 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.4-ck3; KDE/4.5.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104262349.36185.marogge@onlinehome.de>
X-Provags-ID: V02:K0:i/QgnOiJAOYKIoLWNglgrHKntd5bhOxKNGHtnXFNVmP
 F1M8qjJqnzv7K33JVyuDUMXIvBCZdHqUxqGEJ5atnJhIDZ44Qt
 KcKB+yBQAndTRR5mosLZ0+TII/VtcSHxMcrBCvtHFsur+hKT1/
 CmJ9UaJ4IcLLlti2d/F+RU3tWdqzNugZq/yAcufiM7FUByMwbs
 EgyOCi4GeHUVmHtaVDasA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin wrote:

> wzab wrote:
> 
>> Today I have experienced two "GPU hungs" on machine with 82865G chipset
>> working with 2.6.38.2 kernel
>> In the /var/log/syslog I have found the following errors:
>> 
>> [...]
>> 
> 
> Hi, just for info, I seemingly had the same error occurring yesterday, but
> I also failed to retrieve information from the debugfs. Also on 2.6.38.2,
> chipset being H55 Express. Seems to happen after a long uptime. I will be
> more careful to retrieve debug information next time.
> [...]

Hi,

there have been a few "GPU hung" reports with i915 on 2.6.38.x by now. I have 
just collected some data from debugfs and created a bugzilla entry:

https://bugs.freedesktop.org/show_bug.cgi?id=36617

Martin
