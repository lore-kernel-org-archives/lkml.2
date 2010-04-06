Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab0DFIqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 04:46:49 -0400
Received: from smtp.nokia.com ([192.100.105.134]:22507 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab0DFIqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 04:46:46 -0400
Subject: Re: [PATCH] mtd: Extend physmap_of to let the device tree specify
 the parition probe
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20100309192756.GC30462@obsidianresearch.com>
References: <20100309192756.GC30462@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 11:44:38 +0300
Message-ID: <1270543478.6754.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Apr 2010 08:46:04.0684 (UTC) FILETIME=[97B0CCC0:01CAD565]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 12:27 -0700, Jason Gunthorpe wrote:
> This is to support custom partitioning schemes for embedded PPC. To use
> define your own mtd_part_parser and then add something like:
>    linux,part-probe = "my_probe", "cmdlinepart";
> To the board's dts file.
> 
> If linux,part-probe is not specified then this behaves the same as before.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Taken to my l2-mtd-2.6.git / dunno

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

