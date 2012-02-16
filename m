Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab2BPUVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:21:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab2BPUVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:21:54 -0500
Date: Thu, 16 Feb 2012 15:21:37 -0500
From: David Teigland <teigland@redhat.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Christine Caulfield <ccaulfie@redhat.com>,
        Danny Kukawka <dkukawka@suse.de>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/dlm/rcom.c: included member.h twice
Message-ID: <20120216202137.GA4231@redhat.com>
References: <1329400521-31738-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329400521-31738-1-git-send-email-danny.kukawka@bisect.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 02:55:21PM +0100, Danny Kukawka wrote:
> fs/dlm/rcom.c included 'member.h' twice, remove the duplicate.

I'll fold this into the current patch I'm working on.

> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  fs/dlm/rcom.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
> index ac5c616..3464d6c 100644
> --- a/fs/dlm/rcom.c
> +++ b/fs/dlm/rcom.c
> @@ -23,7 +23,6 @@
>  #include "memory.h"
>  #include "lock.h"
>  #include "util.h"
> -#include "member.h"
>  
>  
>  static int rcom_response(struct dlm_ls *ls)
> -- 
> 1.7.8.3
