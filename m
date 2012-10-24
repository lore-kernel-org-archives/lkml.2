Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934023Ab2JXBIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 21:08:31 -0400
Received: from ironclad.mail.utexas.edu ([146.6.25.7]:42842 "EHLO
	ironclad.mail.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933806Ab2JXBIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 21:08:30 -0400
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2012 21:08:30 EDT
X-Utexas-Sender-Group: RELAYLIST-AEMS
X-IronPort-MID: 217912661
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEADQ8h1CsEEdW/2dsb2JhbABEhSu9X4IeAQEEATotEgULCAMYHhAUKCEOBYd+BqpyhxuJCBSLTAmFdWADiFuNFolChniDDYE8Ah4G
X-IronPort-AV: E=Sophos;i="4.80,638,1344229200"; 
   d="scan'208";a="217912661"
X-Utexas-Seen-Outbound: true
Date: Tue, 23 Oct 2012 19:58:40 -0500
From: Kumar Appaiah <a.kumar@alumni.iitm.ac.in>
To: Kees Cook <keescook@chromium.org>
CC: <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 004/193] Documentation/laptops: remove CONFIG_EXPERIMENTAL
Message-ID: <20121024005840.GA8014@bluemoon.alumni.iitm.ac.in>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-5-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1351022666-6960-5-git-send-email-keescook@chromium.org>
X-OS: Linux odessa 3.4.0 x86_64
X-Operating-System: Linux odessa 3.4.0 x86_64
X-Editor: GNU Emacs 23.4.1
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 01:01:17PM -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.

I am not really involved in this, other than the fact that I made some
small changes to this documentation file. Thus, I recuse myself from
having to review/make a decision on this patch! :-)

Thanks.

Kumar

> CC: Rob Landley <rob@landley.net>
> CC: Kumar Appaiah <a.kumar@alumni.iitm.ac.in>
> CC: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Documentation/laptops/thinkpad-acpi.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
> index 9d66682..cf7bc6c 100644
> --- a/Documentation/laptops/thinkpad-acpi.txt
> +++ b/Documentation/laptops/thinkpad-acpi.txt
> @@ -1398,7 +1398,7 @@ Sysfs notes:
>  EXPERIMENTAL: UWB
>  -----------------
>  
> -This feature is marked EXPERIMENTAL because it has not been extensively
> +This feature is considered EXPERIMENTAL because it has not been extensively
>  tested and validated in various ThinkPad models yet.  The feature may not
>  work as expected. USE WITH CAUTION! To use this feature, you need to supply
>  the experimental=1 parameter when loading the module.
> -- 
> 1.7.9.5

-- 
Kumar Appaiah
