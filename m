Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab0G1UrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:47:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:64220 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab0G1UrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:47:09 -0400
Message-ID: <4C50973F.5030709@windriver.com>
Date: Wed, 28 Jul 2010 15:46:55 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [Kgdb-bugreport] [PATCH] kgdb: remove custom hex_to_bin()implementation
References: <1276767215-4217-1-git-send-email-andy.shevchenko@gmail.com>
In-Reply-To: <1276767215-4217-1-git-send-email-andy.shevchenko@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jul 2010 20:46:56.0637 (UTC) FILETIME=[048AD2D0:01CB2E96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 04:33 AM, Andy Shevchenko wrote:
> From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
>
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> Cc: Jason Wessel <jason.wessel@windriver.com>
> Cc: Martin Hicks <mort@sgi.com>
> Cc: kgdb-bugreport@lists.sourceforge.net
>   
Looks fine to me as the hex_to_bin is a drop in replacement.

I'll queue this to merge in 2.6.36.   It will appear in linux-next in
the day.

Thanks,
Jason.

