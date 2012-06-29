Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2F2QLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:11:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:44899 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336Ab2F2QLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:11:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="171683566"
Date: Fri, 29 Jun 2012 18:22:46 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd/ab5500: delete ab5500-core.h
Message-ID: <20120629162246.GS22806@sortiz-mobl>
References: <1339017911.21725.20.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339017911.21725.20.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Jun 06, 2012 at 11:25:11PM +0200, Paul Bolle wrote:
> Commit 72fb92200d6c31b9982c06784e4bcff2f5b7d8b6 ("mfd/ab5500: delete
> AB5500 support") deleted all files that used ab5500-core.h. That file
> apparently was simply overlooked. Delete it too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested with "git grep" only.
> 
>  drivers/mfd/ab5500-core.h |   87 ---------------------------------------------
>  1 files changed, 0 insertions(+), 87 deletions(-)
>  delete mode 100644 drivers/mfd/ab5500-core.h
Patch applied to my for-linus branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
