Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab1HOMWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 08:22:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48340 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab1HOMWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 08:22:37 -0400
Message-ID: <4E490F8A.3090702@petalogix.com>
Date: Mon, 15 Aug 2011 14:22:34 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Eli Billauer <eli@billauer.co.il>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Microblaze, DMA and cache: Lack of sync functions?
References: <4E464DF0.7030401@billauer.co.il>
In-Reply-To: <4E464DF0.7030401@billauer.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eli Billauer wrote:
> Hello,
> 
> 
> Before I make a needless hack, please correct me if I'm wrong: in 
> arch/microblaze/kernel/dma.c, the sync_single_for_cpu, 
> sync_single_for_device and friends are not set in the dma_direct_ops 
> structure (and not implemented), so calls from drivers to the 
> corresponding functions will do nothing. Since the Microblaze cache 
> doesn't update automatically on DMA operations, this looks like a bug to 
> me: The driver thinks the cache has been flushed or updated, but it 
> actually hasn't.
> 
> 
> Map and unmap methods are indeed implemented and registered, and they 
> both call an internal function to sync the cache. So why are there no 
> sync functions?
> 

It is not the bug just unimplemented feature and I haven't had any problem
that these functions are not implemented.
Implementation should be pretty straight forward. Patches welcomed.

Thanks,
Michal




-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
