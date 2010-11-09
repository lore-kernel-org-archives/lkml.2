Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0KIJfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:35:21 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:22477 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab0KIJfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:35:19 -0500
Date: Tue, 9 Nov 2010 10:35:11 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/32] drivers/hwmon/pc87427.c: Use pr_fmt and
 pr_<level>
Message-ID: <20101109103511.3cf94514@endymion.delvare>
In-Reply-To: <8a5f258d9b494988e1ca2ded006423d9cdab8e54.1287556801.git.joe@perches.com>
References: <20101020035346.GA20178@ericsson.com>
	<8a5f258d9b494988e1ca2ded006423d9cdab8e54.1287556801.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 23:51:44 -0700, Joe Perches wrote:
> Added #define pr_fmt KBUILD_MODNAME ": " fmt
> Converted printks to pr_<level>
> Coalesced any long formats
> Removed prefixes from formats
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/hwmon/pc87427.c |   26 +++++++++++++-------------
>  1 files changed, 13 insertions(+), 13 deletions(-)

Applied, thanks.

-- 
Jean Delvare
