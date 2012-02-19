Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab2BSGtF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 01:49:05 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56520 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab2BSGtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 01:49:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of thomas.weber.linux@googlemail.com designates 10.14.120.209 as permitted sender) smtp.mail=thomas.weber.linux@googlemail.com; dkim=pass header.i=thomas.weber.linux@googlemail.com
Message-ID: <4F409BAF.9070809@gmail.com>
Date: Sun, 19 Feb 2012 07:50:23 +0100
From: Thomas Weber <thomas.weber.linux@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120212 Thunderbird/10.0.1
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>,
        Thomas Weber <weber@corscience.de>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Small fixes for w1_bq27000 driver
References: <20120219020910.4958.46866.stgit@notabene.brown>
In-Reply-To: <20120219020910.4958.46866.stgit@notabene.brown>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 03:10 AM, NeilBrown wrote:
> The following three patches fix a problem with the w1 interface for
> the bq27000 battery charge meter, and remove some unnecessary code.
>
> thanks,
> NeilBrown
>
>
> ---
>
> NeilBrown (3):
>        w1_bq27000: Only one thread can access the bq27000 at a time.
>        w1_bq27000 - remove w1_bq27000_write
>        w1_bq27000: remove unnecessary NULL test.
>
>
>   drivers/w1/slaves/w1_bq27000.c |   19 ++-----------------
>   1 files changed, 2 insertions(+), 17 deletions(-)
>
Hello Neil,
I have the following problem. The board not correctly reads the values 
from the bq27000. It also doesn't detects if the bq27000 is connected. I 
think it always reads 0xFF.

Do you have an omap3 board and a bq27000 battery?

Regards,

Thomas


