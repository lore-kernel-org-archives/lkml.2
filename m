Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0LIINj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 03:13:39 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34506 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab0LIINh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 03:13:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EuER8gmLbawPH24N+7VzfoV5db3cVAmXmpj7nbosoQ31SYNy1S5mlU7TPJK7UcepD6
         Bu2oZ2fZGNjkcQ35YNAGZQ+eb5AFR/AbbQRxJUg4N4V/doq4qsWtt+lj+bjo0EpaYcb7
         pWVQgC34VhrcEWSneAk+f1RIk6KNPXjyCflmU=
Date: Thu, 9 Dec 2010 00:13:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7] ideapad: select INPUT_SPARSEKMAP
Message-ID: <20101209081329.GC6233@core.coreip.homeip.net>
References: <1291881376-4729-1-git-send-email-ike.pan@canonical.com>
 <1291881440-4846-1-git-send-email-ike.pan@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291881440-4846-1-git-send-email-ike.pan@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 03:57:20PM +0800, Ike Panhc wrote:
> Thanks for Dave Hansen report the problem. If CONFIG_INPUT_SPARSEKMAP is not
> set, when building, you will have error message:
> 
>   ERROR: "sparse_keymap_setup" [drivers/platform/x86/ideapad-laptop.ko] undefined!
>   ERROR: "sparse_keymap_free" [drivers/platform/x86/ideapad-laptop.ko] undefined!
>   ERROR: "sparse_keymap_report_event" [drivers/platform/x86/ideapad-laptop.ko] undefined!
> 
> To select INPUT_SPARSEKMAP solve this issue.
> 
> Ref: http://lkml.org/lkml/2010/12/2/340
>

I'd recommend folding this patch together with the patch that introduces
sparse keymap usage. Leaving them separated served only to risk compile
errors during bisecting.

Thanks.

-- 
Dmitry
