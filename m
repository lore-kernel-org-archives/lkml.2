Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1HOMQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 08:16:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42564 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab1HOMQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 08:16:23 -0400
Message-ID: <4E490E14.3060902@petalogix.com>
Date: Mon, 15 Aug 2011 14:16:20 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Eli Billauer <eli@billauer.co.il>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] microblaze: Removed U-Boot image creation from simpleImage
 rule
References: <4E3ABDB7.1000300@billauer.co.il>
In-Reply-To: <4E3ABDB7.1000300@billauer.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eli Billauer wrote:
> The simpleImage rule used to create a U-boot image as well, resulting in
> a build error if the mkimage utility wasn't set up. A line in the Makefile
> was removed, so "make simpleImage.(something)" now does what one should 
> expect.

Agree that we should remove it but that patch is incomplete.
Please do these two more changes.
1. Remove uimage generation for linux.bin - the same reason as you describe
2a. Add support for linux.bin.ub or uImage if you like
2b. Add support for simpleImage.%.ub

I don't want to lose possibility to create u-boot formats.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
