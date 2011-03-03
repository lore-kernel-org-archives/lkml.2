Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab1CCJhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 04:37:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47386 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab1CCJhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 04:37:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] Documentation/power/states.txt: fix repetition
Date: Thu, 3 Mar 2011 10:37:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7+; KDE/4.4.4; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <1299142660-5859-1-git-send-email-gnurou@gmail.com>
In-Reply-To: <1299142660-5859-1-git-send-email-gnurou@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201103031037.31619.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 03, 2011, Alexandre Courbot wrote:
> Remove repetition of "called swsusp".
> 
> Signed-off-by: Alexandre Courbot <gnurou@gmail.com>

This patch has already been applied to suspend-2.6/linux-next.
Is this a new version?

Rafael


> ---
>  Documentation/power/states.txt |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/power/states.txt b/Documentation/power/states.txt
> index 34800cc..4416b28 100644
> --- a/Documentation/power/states.txt
> +++ b/Documentation/power/states.txt
> @@ -62,12 +62,12 @@ setup via another operating system for it to use. Despite the
>  inconvenience, this method requires minimal work by the kernel, since
>  the firmware will also handle restoring memory contents on resume. 
>  
> -For suspend-to-disk, a mechanism called swsusp called 'swsusp' (Swap
> -Suspend) is used to write memory contents to free swap space.
> -swsusp has some restrictive requirements, but should work in most
> -cases. Some, albeit outdated, documentation can be found in
> -Documentation/power/swsusp.txt. Alternatively, userspace can do most
> -of the actual suspend to disk work, see userland-swsusp.txt.
> +For suspend-to-disk, a mechanism called 'swsusp' (Swap Suspend) is used
> +to write memory contents to free swap space. swsusp has some restrictive
> +requirements, but should work in most cases. Some, albeit outdated,
> +documentation can be found in Documentation/power/swsusp.txt.
> +Alternatively, userspace can do most of the actual suspend to disk work,
> +see userland-swsusp.txt.
>  
>  Once memory state is written to disk, the system may either enter a
>  low-power state (like ACPI S4), or it may simply power down. Powering
> 

