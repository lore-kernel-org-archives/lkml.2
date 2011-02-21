Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab1BUMDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 07:03:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:57796 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446Ab1BUMDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 07:03:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,199,1297065600"; 
   d="scan'208";a="659886980"
Date: Mon, 21 Feb 2011 13:03:02 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2.6.38] mfd: Don't suspend WM8994 if the CODEC is not
 suspended
Message-ID: <20110221120301.GC10686@sortiz-mobl>
References: <1296831463-19643-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296831463-19643-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Feb 04, 2011 at 02:57:43PM +0000, Mark Brown wrote:
> ASoC supports keeping the audio subsysetm active over suspend in order
> to support use cases such as audio passthrough from a cellular modem
> with the main CPU suspended. Ensure that we don't power down the CODEC
> when this is happening by checking to see if VMID is up and skipping
> suspend and resume when it is. If the CODEC has suspended then it'll
> turn VMID off before the core suspend() gets called.
I applied this patch to both for-next and for-linus branch, many thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
