Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850Ab1ION6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:58:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:49264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab1ION6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:58:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="48777239"
Date: Thu, 15 Sep 2011 16:01:33 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/2] mfd: ab5500 chip register access
Message-ID: <20110915140133.GC32263@sortiz-mobl>
References: <1307616640-2013-1-git-send-email-mattias.wallin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307616640-2013-1-git-send-email-mattias.wallin@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattias,

On Thu, Jun 09, 2011 at 12:50:40PM +0200, Mattias Wallin wrote:
> The analog baseband chip ab5500 is a multi functional chip
> containing regulators, charging, gpio, USB and accessory detect.
> It also contain various multimedia functionalities like digital
> encoder and audio codec.
> The core driver added with this patch provides register access via
> i2c via PRCMU. Event handling implemented as irq_chip will come in
> future patches since it depends on PRCMU functionality not yet
> implemented.
This patch looks good to me. However, I think the 800 lines of debugfs code
could live in an ab5500-debugfs.c file. Could you please do that ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
