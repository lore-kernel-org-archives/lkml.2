Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2KZLWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:22:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:20928 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab2KZLWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:22:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,319,1352102400"; 
   d="scan'208";a="254253744"
Date: Mon, 26 Nov 2012 12:22:47 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH] mfd: jz4740-adc: use devm_kzalloc
Message-ID: <20121126112247.GS12685@sortiz-mobl>
References: <1353755678-28275-1-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353755678-28275-1-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Devendra,

On Sat, Nov 24, 2012 at 06:14:38AM -0500, Devendra Naga wrote:
> use devm_kzalloc and remove the error path free'ing and unload free'ing
> as the devm resource functions free them.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/mfd/jz4740-adc.c | 23 +++++++----------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
