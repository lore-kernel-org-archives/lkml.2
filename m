Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1G3TMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 15:12:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57090 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab1G3TMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:12:13 -0400
Date: Sat, 30 Jul 2011 12:12:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yufeng Shen <miletus@chromium.org>
Cc: linux-input@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Chris Leech <christopher.leech@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH v2] Input: atmel_mxt_ts - Report pressure information
 from the driver
Message-ID: <20110730191206.GF5686@core.coreip.homeip.net>
References: <1311787695-28147-1-git-send-email-miletus@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311787695-28147-1-git-send-email-miletus@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yufeng,

On Wed, Jul 27, 2011 at 01:28:15PM -0400, Yufeng Shen wrote:
> Atmel mxt1386 touch controller has the touch pressure information but
> the current driver atmel_mxt_ts does not expose it to the user space.
> This patch makes the driver report the touch pressure information to
> user space.
> 

What about other controllers supported by this driver? Do all of them
report pressure? Do all have the same reporting range?

Thanks.

-- 
Dmitry
