Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1IMK4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:56:09 -0400
Received: from mail-ew0-f52.google.com ([209.85.215.52]:61976 "EHLO
	mail-ew0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab1IMK4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:56:07 -0400
Message-ID: <4E6F36C1.50507@gmail.com>
Date: Tue, 13 Sep 2011 12:56:01 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Mateusz Murawski <matowy@tlen.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: VT-d / iommu problem on Intel S3210SH
References: <5d3988ad.24b007ce.4e6e07a7.c204f@tlen.pl>
In-Reply-To: <5d3988ad.24b007ce.4e6e07a7.c204f@tlen.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Mateusz,

On 09/12/2011 03:22 PM, Mateusz Murawski wrote:
> Hi
> I have problem with Intel VT for Directed I/O.
> When I enable this option in bios, my system (Fedora 15) can't start.
> Kernel 2.6.40.4-5.fc15.x86_64
> Bios S3200X38.86B.00.00.0052
>
> Last lines from dmesg
>
> [    5.357181] DRHD: handling fault status reg 3
> [    5.358179] DMAR:[DMA Write] Request device [02:08.0] fault addr ffe8a000
> [    5.358179] DMAR:[fault reason 02] Present bit in context entry is clear
> [   24.087406] dracut Warning: No root device "block:/dev/disk/by-uuid/1c624f0d-4593-4653-a4ce-b7af80d549ff" found
>
> Full dmesgs
> dmesg_bad_2.6.40 VT-d enable http://pastebin.com/AXAByHBh
> dmesg_good_2.6.40 VT-d enable iommu=off http://pastebin.com/8zrMRiin
>
> Please let me know if you need more information. I have access by serial console.
>
Does that cpu have vt-d support?

http://ark.intel.com/products/35432 doesn't list it. If you enable it
for the mainboard, but cpu has no support, weird things happen.

For comparison a cpu that does:
http://ark.intel.com/products/52209

~Maarten
