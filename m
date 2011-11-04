Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab1KDPYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 11:24:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38784 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab1KDPYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 11:24:13 -0400
Date: Fri, 4 Nov 2011 15:24:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Afzal Mohammed <afzal@ti.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, sameo@linux.intel.com,
        nsekhar@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: TPS65910: Improvements
Message-ID: <20111104152411.GB28615@opensource.wolfsonmicro.com>
References: <1320410912-20293-1-git-send-email-afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320410912-20293-1-git-send-email-afzal@ti.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 06:18:32PM +0530, Afzal Mohammed wrote:
> Two changes,

...should be in two separate commits.

> 2. struct tps65910_platform_data usage can be avoided
>  by making use of struct tps65910_board to simplify
>  driver. Hence remove it

Why is this a simplification?  Note that one of the reasons platform
data is kept separate from any runtime data the device needs is that it
makes the configuration available easier to see and understand.
