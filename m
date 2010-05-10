Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab0EKAZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 20:25:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383Ab0EKAZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 20:25:02 -0400
Date: Mon, 10 May 2010 17:22:54 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: InKi Dae <daeinki@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] s3c-fb: added patch series for s5pv210 and some
 features.
Message-Id: <20100510172254.1f28f07c.akpm@linux-foundation.org>
In-Reply-To: <m2g90b950fc1005070059k99d138efr4bfa7de44c58fdd0@mail.gmail.com>
References: <m2g90b950fc1005070059k99d138efr4bfa7de44c58fdd0@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010 16:59:56 +0900 InKi Dae <daeinki@gmail.com> wrote:

> this includes three patch series and divides previous patch
> into smaller part.
> 
> so Andrew, please remove my previous patch,
> s3c-fb-add-s5pv210-support-and-some-features.patch from mm tree.
> 
> patch contents are as following.
> 
> 1. s3c_fb_1_3.patch
>   - as patch for supporting s5pv210, CH_ENABLE bit of SHAD
>     register should be enabled to enable window layer on s5pv210.
> 
> 2. s3c_fb_2_3.patch
>    - s5pv210 has five window layers (window0 ~ 4), among them,
>      window0 ~ 2 could be used for local path with fimc(capture device)
>      and fimd writeback feature so this patch makes default window
>      layer for UI to be set at machine code.
> 
> 3. s3c_fb_3_3.patch
>    - it has been working fine at 16bpp but in case of pixel format
>      more then 24bpp it would occur distortedness situation
>      on that mode. so this patch set the word swap control bit of
>      WINCONx to 1 as default value. but it should be set to 0
>      in case that each ENLOCAL bit of WINCON0 ~ 2 registers
>      is enabled. this issue would be solved with local path feature soon.

I prefer not to receive patches this way, sorry.  I will need to detach
the attachments, copy-n-paste the changelogs and signoffs and then
invent meaningful English-language titles for each patch.

The problem is the last part.  The titles I choose may be
inappropriate, and if anyone in a year's time tries to find the history
of a patch by googling for the title, they may not be able to find this
email thread.  A well-chosen title becomes a nice search key for looking
up the patch in reviewion control systems and on the 'net.

There are reasons for the conventions, so please let's be conventional.
Send it as three sequences-numbered emails, one with a carefully chosen
title/Subject: and each one with its own changelog, signoffs, etc.

Also, if you _must_ use attachments, please use text/plain mimetypes,
thanks.
