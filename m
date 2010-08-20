Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab0HTWQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 18:16:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:46240 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab0HTWQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 18:16:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,242,1280732400"; 
   d="scan'208";a="649781192"
Date: Sat, 21 Aug 2010 00:16:29 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MFD: switch AB3100 to use MFD cells
Message-ID: <20100820221628.GO3650@sortiz-mobl>
References: <1282292832-4604-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282292832-4604-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Aug 20, 2010 at 10:27:12AM +0200, Linus Walleij wrote:
> This switches the AB3100 core driver to using MFD cells for
> subdevices instead of spawning common platform devices.
Good boy :) Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
