Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0KIJWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:22:03 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:7993 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab0KIJV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:21:57 -0500
Date: Tue, 9 Nov 2010 10:21:48 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/32] drivers/hwmon/it87.c: Use pr_fmt and pr_<level>
Message-ID: <20101109102148.0bb0a283@endymion.delvare>
In-Reply-To: <ca9c0c999e7108d20fab9d4be3b310736bbdd7a6.1287556801.git.joe@perches.com>
References: <20101020035346.GA20178@ericsson.com>
	<ca9c0c999e7108d20fab9d4be3b310736bbdd7a6.1287556801.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 23:51:39 -0700, Joe Perches wrote:
> Added #define pr_fmt KBUILD_MODNAME ": " fmt
> Converted printks to pr_<level>
> Coalesced any long formats
> Removed prefixes from formats
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/hwmon/it87.c |   30 ++++++++++++++----------------
>  1 files changed, 14 insertions(+), 16 deletions(-)

Applied, thanks.

-- 
Jean Delvare
