Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936473Ab0COOOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:14:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:48598 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936310Ab0COOOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:14:12 -0400
Date: Mon, 15 Mar 2010 15:14:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rob Landley <rob@landley.net>
Cc: trivial@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/filesystems/proc.txt typo fix.
In-Reply-To: <201003011030.43877.rob@landley.net>
Message-ID: <alpine.LNX.2.00.1003151513550.18642@pobox.suse.cz>
References: <201003011030.43877.rob@landley.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Mar 2010, Rob Landley wrote:

> From: Rob Landley <rob@landley.net>
> 
> Typo fix for a filename in procfs documentation.
> 
> Signed-off-by: Rob Landley <rob@landley.net>
> ---
> 
>  Documentation/filesystems/proc.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index 0d07513..14e6d29 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -297,7 +297,7 @@ Table 1-4: Contents of the stat files (as of 2.6.30-rc7)
>    cgtime        guest time of the task children in jiffies
>  ..............................................................................
>  
> -The /proc/PID/map file containing the currently mapped memory regions and
> +The /proc/PID/maps file containing the currently mapped memory regions and
>  their access permissions.
>  
>  The format is:

Good catch, applied. Thanks Rob.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
