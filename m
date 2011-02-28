Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1B1VTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:19:30 -0500
Received: from kroah.org ([198.145.64.141]:55165 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab1B1VT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:19:29 -0500
Date: Mon, 28 Feb 2011 13:16:32 -0800
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: RFC: [PATCH 1/5] staging: sep: rename sep_driver.c to
 sep_main.c
Message-ID: <20110228211632.GA8851@kroah.com>
References: <1298869848-4283-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298869848-4283-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 09:10:48PM -0800, Mark Allyn wrote:
> This allows adding sep_crypto.c and yet keep the driver named sep_driver
> 
> This only renames the file and changes the Makefile. No changes
> made to content of c source file
> 
> Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
> ---
>  drivers/staging/sep/Makefile     |    2 +-
>  drivers/staging/sep/sep_driver.c | 3348 --------------------------------------
>  drivers/staging/sep/sep_main.c   | 3348 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 3349 insertions(+), 3349 deletions(-)
>  delete mode 100644 drivers/staging/sep/sep_driver.c
>  create mode 100644 drivers/staging/sep/sep_main.c

As you used git to create this patch, can you have git create the
"rename" patch instead so that we can really see that you did it this
way?

thanks,

greg k-h
