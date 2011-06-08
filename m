Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1FHT1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:27:47 -0400
Received: from mail.perches.com ([173.55.12.10]:2637 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab1FHT1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:27:46 -0400
Subject: Re: [PATCH 2/2 v2] ramoops: add new line to each print
From: Joe Perches <joe@perches.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xiyou.wangcong@gmail.com,
        stevie.trujillo@gmail.com, kyungmin.park@samsung.com
In-Reply-To: <4DEFC885.2080202@gmail.com>
References: <4DE10B58.1010005@gmail.com>  <4DEE5737.9060404@gmail.com>
	 <1307550164.16453.2.camel@Joe-Laptop>  <4DEFC885.2080202@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 12:27:44 -0700
Message-ID: <1307561264.16453.10.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 21:07 +0200, Marco Stornelli wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> Add new line to each print.
> diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
[]
> @@ -186,6 +188,8 @@ static int __init ramoops_init(void)
>  		 * if we didn't find a platform device, we use module parameters
>  		 * building platform data on the fly.
>  		 */
> +		pr_info("platform device not found, "
> +			"using module parameters\n");

Thanks Marco, I think that looks better.

Trivia:

This fits on a single line and it's not generally a
good thing to split a format across multiple lines.

cheers, Joe

