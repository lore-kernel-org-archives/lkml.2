Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab2GRRJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:09:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36938 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab2GRRJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:09:51 -0400
MIME-Version: 1.0
In-Reply-To: <1342630288.9551.19.camel@joe2Laptop>
References: <1342611251-16935-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1342630288.9551.19.camel@joe2Laptop>
Date: Wed, 18 Jul 2012 20:09:50 +0300
Message-ID: <CAHp75Vftn9zSjHEWR8i-SxNO4Q1JWSiyqq5JU6G4DZkattyz7Q@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: Cleanup logging messages
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 7:51 PM, Joe Perches <joe@perches.com> wrote:
> Use a more current logging style.
>
> Add pr_fmt to prefix dmaengine: to messages.
> Convert printk(KERN_ERR to pr_err(.
> Convert embedded function name use to "%s: ", __func__
> Align arguments.
>
> Original-patch-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>
> Hi Andy.  Maybe a slightly larger patch is better.
Fine by me.


-- 
With Best Regards,
Andy Shevchenko
