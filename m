Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162998Ab2GMOJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 10:09:19 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:54378 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722Ab2GMOJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:09:14 -0400
Date: Fri, 13 Jul 2012 15:09:08 +0100
From: Chris Webb <chris@arachsys.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Michael Chan <mchan@broadcom.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] bnx2: update bnx2-mips-09 firmware to bnx2-mips-09-6.2.1b
Message-ID: <20120713140907.GT13885@arachsys.com>
References: <20120713130405.GS13885@arachsys.com>
 <1342186932.3265.8364.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342186932.3265.8364.camel@edumazet-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> Have you read firmware/README.AddingFirmware ?

I hadn't, but now I have, and if firmware upgrades are considered 'adding
new firmware', I agree this patch is wrong, and should have just removed the
obsolete bnx2-mips-09-6.2.1a file that is no longer used by the bnx2 driver.

However, not having dealt with cards that need these kinds of horrible
binary blobs before, I'm a little uncertain how I should be building
upstream kernels with CONFIG_FIRMWARE_IN_KERNEL and pulling in the correct
blobs from a linux-firmware checkout.

Is there a more automatic method than going through the source for each
configured driver and setting CONFIG_EXTRA_FIRMWARE manually to list the
relevant firmwares? Is there any way to give the kernel the location of
linux-firmware and have it compile in everything needed for the selected
drivers, as used to happen with the firmware/ subdirectory?
CONFIG_EXTRA_FIRMWARE_DIR doesn't seem to do anything with
CONFIG_EXTRA_FIRMWARE empty, so I don't think it does what I'm hoping?

Cheers,

Chris.
