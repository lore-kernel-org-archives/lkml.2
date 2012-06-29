Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2F2LEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 07:04:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:7917 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab2F2LEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 07:04:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="164607300"
Date: Fri, 29 Jun 2012 13:15:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][TRIVIAL] mfd: Remove unused variable "desc" from
 function da9052_device_init.
Message-ID: <20120629111542.GH4846@sortiz-mobl>
References: <1337790648-5483-1-git-send-email-krzysztof.wilczynski@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1337790648-5483-1-git-send-email-krzysztof.wilczynski@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On Wed, May 23, 2012 at 05:30:48PM +0100, Krzysztof Wilczynski wrote:
> This is to address the following warning during compilation time:
> 
>   drivers/mfd/da9052-core.c: In function ‘da9052_device_init’:
>   drivers/mfd/da9052-core.c:646: warning: unused variable ‘desc’
> 
> This variable is indeed no longer in use (change can be traced back
> to commit: 8614419451d88bf99fff7f5e468fe45f8450891e).
> 
> Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
> ---
>  drivers/mfd/da9052-core.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
Applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
