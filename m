Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0KIJZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:25:17 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:33227 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab0KIJZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:25:13 -0500
Date: Tue, 9 Nov 2010 10:25:04 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/32] drivers/hwmon/lm78.c: Use pr_fmt and pr_<level>
Message-ID: <20101109102504.327b88a3@endymion.delvare>
In-Reply-To: <35be973bc0b3c4866421f001dabfbcab69093f72.1287556801.git.joe@perches.com>
References: <20101020035346.GA20178@ericsson.com>
	<35be973bc0b3c4866421f001dabfbcab69093f72.1287556801.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 23:51:42 -0700, Joe Perches wrote:
> Added #define pr_fmt KBUILD_MODNAME ": " fmt
> Converted printks to pr_<level>
> Coalesced any long formats
> Removed prefixes from formats
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/hwmon/lm78.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)

Applied, thanks.

-- 
Jean Delvare
