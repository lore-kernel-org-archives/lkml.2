Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab1G0GTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:19:13 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42014 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab1G0GTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:19:11 -0400
MIME-Version: 1.0
In-Reply-To: <1310520405-1558-3-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1310520405-1558-1-git-send-email-Gregory.Dietsche@cuw.edu>
	<1310520405-1558-3-git-send-email-Gregory.Dietsche@cuw.edu>
Date: Wed, 27 Jul 2011 08:19:11 +0200
X-Google-Sender-Auth: AsmEFMG1ev5bkIVHi1atLL8RzbM
Message-ID: <CAAxaTiNPCwF5atmufeTA8wGo=_v3asxj15fP46j4Xu9mjroj6A@mail.gmail.com>
Subject: Re: [PATCH 2/3] coccinelle.txt: add documentation of PARALLEL= flag
From: Nicolas Palix <Nicolas.Palix@inria.fr>
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Cc: julia@diku.dk, Gilles.Muller@lip6.fr, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@diku.dk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 3:26 AM, Greg Dietsche <Gregory.Dietsche@cuw.edu> wrote:
> Document the new PARALLEL= option of Coccinelle which
> allows running SmPL scripts in parallel.
>
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Acked-by: Nicolas Palix <npalix.work@gmail.com>
> ---
>  Documentation/coccinelle.txt |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
> index 9495a4b..3bccb50 100644
> --- a/Documentation/coccinelle.txt
> +++ b/Documentation/coccinelle.txt
> @@ -56,7 +56,7 @@ There are two ways to use Coccinelle with the Linux kernel.
>
>  There are a number of optional parameters that can be used with the build target.
>
> -       make coccicheck MODE={patch,report,context,org} COCCI=? M=?
> +       make coccicheck MODE={patch,report,context,org} COCCI=? M=? PARALLEL=?
>
>  MODE:
>        Determines what mode cocci operates in. If no mode is specified
> @@ -71,6 +71,10 @@ M:
>        Limit cocci to a subset of directories. This is very similar to the
>        way the build system works when building modules.
>
> +PARALLEL:
> +       Number of *.cocci SmPL scripts found under scripts/coccinelle/ to run
> +       at the same time.
> +
>
>  Using Coccinelle on the Linux kernel
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> --
> 1.7.2.5
>
>



-- 
Nicolas Palix
http://sardes.inrialpes.fr/~npalix/
