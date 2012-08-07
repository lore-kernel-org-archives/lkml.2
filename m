Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab2HGBh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 21:37:58 -0400
Received: from [65.55.88.13] ([65.55.88.13]:55600 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757149Ab2HGBh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 21:37:56 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI4015Izz1202hzz8275bhz2dh2a8h668h839h944hd24he5bhf0ah107ah)
Date: Mon, 6 Aug 2012 20:35:06 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: <qiang.liu@freescale.com>
CC: <linux-crypto@vger.kernel.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>, <herbert@gondor.hengli.com.au>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <dan.j.williams@gmail.com>, <leoli@freescale.com>
Subject: Re: [PATCH v6 0/8] Raid: enable talitos xor offload for improving
 performance
Message-ID: <20120806203506.bcf31cc63a2d1f55a9695f13@freescale.com>
In-Reply-To: <1344247815-1104-1-git-send-email-qiang.liu@freescale.com>
References: <1344247815-1104-1-git-send-email-qiang.liu@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2012 18:10:15 +0800
<qiang.liu@freescale.com> wrote:

> Changes in v6:
> 	- swap the order of original patch 3/6 and 4/6;
> 	- merge Ira's patch to reduce the size of original patch;
> 	- merge Ira's patch of carma in 8/8;
> 	- update documents and descriptions according to Ira's advice;

fwiw, I gave v5 a test-drive, setting up a RAID5 array on ramdisks
[1], and this patchseries, along with FSL_DMA && NET_DMA set seems
to be holding water, so this series gets my:

Tested-by: Kim Phillips <kim.phillips@freescale.com>

Thanks,

Kim

[1] mdadm --create --verbose --force /dev/md0 --level=raid5 --raid-devices=4 /dev/ram[0123]

