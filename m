Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946446Ab2ESBJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 21:09:29 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:55475 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2ESBJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 21:09:28 -0400
Message-ID: <4FB6F2C6.2060007@tilera.com>
Date: Fri, 18 May 2012 21:09:26 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] tile: fix compile failure on start_kernel in setup.c
References: <1337382021-16108-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1337382021-16108-1-git-send-email-paul.gortmaker@windriver.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/2012 7:00 PM, Paul Gortmaker wrote:
> Commit 293ef7b8288da79112276ddd53902aff75ce7494
>
>     "tile: Use generic init_task"
>
> deleted the file tile/kernel/init_task.c and moved the remaining
> needed code to tile/kernel/setup.c -- but this code references
> start_kernel and setup.c didn't include that, causing this fail:
>
> arch/tile/kernel/setup.c:69:344: error: 'start_kernel' undeclared here (not in a function)
>
> Adding the obvious include fixes it.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

