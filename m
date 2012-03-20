Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab2CTUTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:19:50 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:48356 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756988Ab2CTUTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:19:49 -0400
Message-ID: <4F68E65C.3010406@xenotime.net>
Date: Tue, 20 Mar 2012 13:19:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: remove mach from dontdiff file
References: <201203191334.23749.hartleys@visionengravers.com>
In-Reply-To: <201203191334.23749.hartleys@visionengravers.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 01:34 PM, H Hartley Sweeten wrote:

> The mach entry in the dontdiff file causes all the arch/arm/mach-*/include/mach
> directories to be skipped.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>


Applied.  Thanks.

> ---
> 
> diff --git a/Documentation/dontdiff b/Documentation/dontdiff
> index 0c083c5..b4a898f 100644
> --- a/Documentation/dontdiff
> +++ b/Documentation/dontdiff
> @@ -158,7 +158,6 @@ logo_*.c
>  logo_*_clut224.c
>  logo_*_mono.c
>  lxdialog
> -mach
>  mach-types
>  mach-types.h
>  machtypes.h



-- 
~Randy
