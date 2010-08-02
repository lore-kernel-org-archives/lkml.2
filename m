Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab0HBBwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:52:18 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:35189 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0HBBwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:52:17 -0400
Date: Mon, 2 Aug 2010 02:50:06 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Samuel Ortiz <sameo@linux.intel.com>, lm-sensors@lm-sensors.org,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH RESEND] jz4740-hwmon: check kmalloc() result
Message-ID: <20100802015006.GA5906@linux-mips.org>
References: <1280711795.6538.9.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280711795.6538.9.camel@mola>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 09:16:35AM +0800, Axel Lin wrote:

> From: Axel Lin <axel.lin@gmail.com>
> Date: Mon, 2 Aug 2010 09:02:26 +0800
> Subject: [PATCH] jz4740-hwmon: check kmalloc() result
> 
> If kmalloc() fails exit with -ENOMEM.

Thanks, folded into the existing patch.

  Ralf
