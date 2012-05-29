Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2E2KGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:06:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64054 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab2E2KGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:06:19 -0400
Subject: Re: [PATCH V2] [staging] bcm: Replace the BCM_DEBUG_* and
 BCM_SHOW_* macros with functions
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1338285078-17785-1-git-send-email-devendra.aaru@gmail.com>
References: <1338285078-17785-1-git-send-email-devendra.aaru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 May 2012 12:06:13 +0200
Message-ID: <1338285973.2840.1.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 15:21 +0530, Devendra Naga wrote:
> This patch is made by following the improvements told by Joe Perches,
> replaced the BCM_DEBUG* and BCM_SHOW* macros into functions and added them
> in a file and added macros in the Debug.h file. This patch also improves the if
> check in bcm_show_debug_bitmap,
> 
> the check was
> 	if ((i == 1) || (i == 2) || (i == 4) || (i == 8));
> anyway its a check to find whether its a power of two, and replaces
> it like the following,
> 	if ((i != 0) && !(i & (i - 1)))

So why not using is_power_of_2() ?


