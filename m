Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab2GMVM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:12:26 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1174 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab2GMVMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:12:24 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Subject: Re: [PATCH] bnx2: update bnx2-mips-09 firmware to
 bnx2-mips-09-6.2.1b
From: "Michael Chan" <mchan@broadcom.com>
To: "Chris Webb" <chris@arachsys.com>
cc: "Eric Dumazet" <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20120713140907.GT13885@arachsys.com>
References: <20120713130405.GS13885@arachsys.com>
 <1342186932.3265.8364.camel@edumazet-glaptop>
 <20120713140907.GT13885@arachsys.com>
Date: Fri, 13 Jul 2012 14:12:13 -0700
Message-ID: <1342213933.7472.95.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7C1E50883MK9978167-01-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-13 at 15:09 +0100, Chris Webb wrote: 
> Is there a more automatic method than going through the source for each
> configured driver and setting CONFIG_EXTRA_FIRMWARE manually to list the
> relevant firmwares? Is there any way to give the kernel the location of
> linux-firmware and have it compile in everything needed for the selected
> drivers, as used to happen with the firmware/ subdirectory?
> CONFIG_EXTRA_FIRMWARE_DIR doesn't seem to do anything with
> CONFIG_EXTRA_FIRMWARE empty, so I don't think it does what I'm hoping?
> 

Most users will just download the linux-firmware tree:

//git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

and copy all the firmware files to /lib/firmware.


