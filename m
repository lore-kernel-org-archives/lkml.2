Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab1ILNWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 09:22:52 -0400
Received: from moh1-ve1.go2.pl ([193.17.41.131]:42397 "EHLO moh1-ve1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab1ILNWv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 09:22:51 -0400
Subject: =?UTF-8?Q?VT-d_/_iommu_problem_on_Intel_S3210SH?=
From: =?UTF-8?Q?Mateusz_Murawski?= <matowy@tlen.pl>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Message-ID: <5d3988ad.24b007ce.4e6e07a7.c204f@tlen.pl>
Date: Mon, 12 Sep 2011 15:22:47 +0200
X-Originator: 85.128.3.148
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
I have problem with Intel VT for Directed I/O.
When I enable this option in bios, my system (Fedora 15) can't start.
Kernel 2.6.40.4-5.fc15.x86_64
Bios S3200X38.86B.00.00.0052

Last lines from dmesg

[    5.357181] DRHD: handling fault status reg 3
[    5.358179] DMAR:[DMA Write] Request device [02:08.0] fault addr ffe8a000
[    5.358179] DMAR:[fault reason 02] Present bit in context entry is clear
[   24.087406] dracut Warning: No root device "block:/dev/disk/by-uuid/1c624f0d-4593-4653-a4ce-b7af80d549ff" found

Full dmesgs
dmesg_bad_2.6.40 VT-d enable http://pastebin.com/AXAByHBh
dmesg_good_2.6.40 VT-d enable iommu=off http://pastebin.com/8zrMRiin

Please let me know if you need more information. I have access by serial console.
Thanks
M.Murawski
