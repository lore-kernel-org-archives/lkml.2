Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0KZPvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:51:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:47618 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab0KZPvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:51:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,261,1288594800"; 
   d="scan'208";a="353583808"
Date: Fri, 26 Nov 2010 16:51:28 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/2] MFD: ab8500-debugfs irq support
Message-ID: <20101126155127.GE27663@sortiz-mobl>
References: <1290773229-9119-1-git-send-email-mattias.wallin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290773229-9119-1-git-send-email-mattias.wallin@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattias,

On Fri, Nov 26, 2010 at 01:07:09PM +0100, Mattias Wallin wrote:
> This patch makes it possible to listned for ab8500 interrupts
> from userspace. A sysfs file is dynamically created
> and sysfs_notify is called when an interrupt occurs. This will
> make the userspace poll call to be released.
I think writing a UIO driver for that matter will make your life a lot easier.
And to be honest, having an IRQ handler on a debugfs related piece of code
sounds just wrong.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
