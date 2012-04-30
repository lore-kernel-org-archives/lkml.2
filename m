Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2D3MMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 08:12:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59429 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755384Ab2D3MMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 08:12:08 -0400
Date: Mon, 30 Apr 2012 13:11:26 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yilu Mao <ylmao@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ning Jiang <njiang1@marvell.com>
Subject: Re: [PATCH] ARM: cache-l2x0.c: save aux ctrl for resume in case
 that l2x0 is enabled before init
Message-ID: <20120430121125.GN10632@arm.com>
References: <4F99148B.4020900@marvell.com>
 <20120426094400.GD18136@arm.com>
 <4F991ED6.8060109@marvell.com>
 <20120426102815.GE18136@arm.com>
 <4F9924FB.7070308@marvell.com>
 <20120426103840.GA6294@arm.com>
 <4F9927F2.5060408@marvell.com>
 <20120426105651.GB6294@arm.com>
 <4F992B80.6040207@marvell.com>
 <4F9B8D1C.6090400@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9B8D1C.6090400@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 07:24:28AM +0100, Yilu Mao wrote:
> Do you agree with this patch to be merged?

I would rather re-read the aux_ctrl register again after it was set (if
L2 is disabled) and store this value. It makes sense if some of the bits
are reserved, at least we have the real value.

-- 
Catalin
