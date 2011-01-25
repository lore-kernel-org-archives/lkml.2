Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1AYGL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 01:11:57 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:32839 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1AYGL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 01:11:56 -0500
Date: Tue, 25 Jan 2011 15:11:48 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
        Lennert Buytenhek <buytenh@marvell.com>, Green Wan <gwan@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>, Marek Vasut <marek.vasut@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH] video: da8xx-fb: fix fb_probe error path
Message-ID: <20110125061147.GC11673@linux-sh.org>
References: <1295608686.3976.9.camel@phoenix> <1295495451.20884.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295608686.3976.9.camel@phoenix> <1295495451.20884.3.camel@mola>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 11:50:51AM +0800, Axel Lin wrote:
> Current implementation puts CONFIG_CPU_FREQ at wrong place, CONFIG_CPU_FREQ
> is for lcd_da8xx_cpufreq_deregister not for unregister_framebuffer.

On Fri, Jan 21, 2011 at 07:18:06PM +0800, Axel Lin wrote:
> Current implementation calls pxa168fb_check_var twice in pxa168fb_probe.

Both applied, thanks.
