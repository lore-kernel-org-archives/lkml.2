Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab2DCVdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 17:33:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59798 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab2DCVdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 17:33:50 -0400
Message-ID: <4F7B6C81.3050205@landley.net>
Date: Tue, 03 Apr 2012 16:32:49 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] MAINTAINERS: change in Documentation/ maintainer
References: <4F7B5CFB.1@xenotime.net>
In-Reply-To: <4F7B5CFB.1@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 03:26 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> I'm dropping off as Documentation/ maintainer.
> Rob Landley has agreed to take it over.  Thanks, Rob.
> 
> I'll still be around reviewing patches and testing.
> Stephen, please drop my quilt tree from linux-next.
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Acked-by: Rob Landley <rob@landley.net>

> ---
>  MAINTAINERS |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- lnx-34-rc1.orig/MAINTAINERS
> +++ lnx-34-rc1/MAINTAINERS
> @@ -2322,9 +2322,9 @@ S:	Supported
>  F:	drivers/acpi/dock.c
>  
>  DOCUMENTATION
> -M:	Randy Dunlap <rdunlap@xenotime.net>
> +M:	Rob Landley <rob@landley.net>
>  L:	linux-doc@vger.kernel.org
> -T:	quilt http://xenotime.net/kernel-doc-patches/current/
> +T:	TBD
>  S:	Maintained
>  F:	Documentation/
>  
> 
