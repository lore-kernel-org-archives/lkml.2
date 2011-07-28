Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1G1WbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:31:18 -0400
Received: from void.printf.net ([89.145.121.20]:35797 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab1G1WbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:31:15 -0400
From: Chris Ball <cjb@laptop.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>
Subject: Re: [PATCH] mmc: mmc_test: avoid stalled file in debugfs
References: <095a90240876c249ed33aa36f2543b54a0b68fc2.1311340371.git.andriy.shevchenko@linux.intel.com>
Date: Thu, 28 Jul 2011 18:31:04 -0400
In-Reply-To: <095a90240876c249ed33aa36f2543b54a0b68fc2.1311340371.git.andriy.shevchenko@linux.intel.com>
	(Andy Shevchenko's message of "Fri, 22 Jul 2011 16:13:36 +0300")
Message-ID: <m27h72javr.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Fri, Jul 22 2011, Andy Shevchenko wrote:
> During card removal and inserting cycle the test file in the debugfs could be
> stalled until the host driver removes it. Let's keep the file in the linked
> list and destroy it when card is removed.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Pushed to mmc-next for 3.1 with Per's ACK and suggested change, thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
