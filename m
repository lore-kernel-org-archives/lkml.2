Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab2KUQfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:35:07 -0500
Received: from mga14.intel.com ([143.182.124.37]:48430 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223Ab2KUQfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:35:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,293,1352102400"; 
   d="scan'208";a="171054277"
Date: Wed, 21 Nov 2012 17:35:01 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: lpc_ich: one uninitialized cell is no error
Message-ID: <20121121163501.GB18738@sortiz-mobl>
References: <1353355451.19434.14.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353355451.19434.14.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Mon, Nov 19, 2012 at 09:04:11PM +0100, Paul Bolle wrote:
> At every boot of an (outdated) laptop lpc_ich prints an error:
>     lpc_ich 0000:00:1f.0: I/O space for GPIO uninitialized
> 
> But if one looks at lpc_ich's probe function one notices that the code
> only cares if both lpc_ich_init_wdt() and lpc_ich_init_gpio() fail to
> add any cells. So stop treating the failure to add a single cell as an
> error. Those messages can be printed at notice level. And then only warn
> if no cells were added.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) This patch was written on top of v3.7-rc4 and tested on v3.6.7.
> 
> 1) Please note that this patch prints a warning when no MFD cells are
> added at all. I didn't make that an error because I'm not sure there's
> anything one can do if this happens. Is there?
> 
>  drivers/mfd/lpc_ich.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
