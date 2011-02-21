Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1BULNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 06:13:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:24600 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab1BULNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 06:13:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,199,1297065600"; 
   d="scan'208";a="711264255"
Date: Mon, 21 Feb 2011 12:13:40 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Subject: Re: [PATCH] mfd: AB8500 system control driver
Message-ID: <20110221111339.GA10686@sortiz-mobl>
References: <1296635976-4384-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296635976-4384-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Feb 02, 2011 at 09:39:36AM +0100, Linus Walleij wrote:
> This adds a pretty straight-forward system control driver for the
> AB8500. This driver will be used from the core platform, e.g the
> clock tree implementation in the machine code, and is by nature
> singleton.
> 
> There are a few simple functions to read, write, set and clear
> registers so that the machine code can control its own foundation.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
