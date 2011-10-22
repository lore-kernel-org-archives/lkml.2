Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1JVHn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 03:43:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43306 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1JVHn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 03:43:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAHFnbA=sz+_8rESX212aRphen5YCC6ikoX2riprCZBh4wp1O9Q@mail.gmail.com>
References: <CAHFnbA=sz+_8rESX212aRphen5YCC6ikoX2riprCZBh4wp1O9Q@mail.gmail.com>
Date: Sat, 22 Oct 2011 16:43:27 +0900
Message-ID: <CAHFnbA=8ENL3vavU-_iTGfGt0tezG4SUyzTVdFNwbPgckzVSyA@mail.gmail.com>
Subject: Re: [PATCH] Makefile: Remove duplicate description of "make RECORDMCOUNT_WARN=1"
From: Jongman Heo <jongman.heo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/22 Jongman Heo <jongman.heo@gmail.com>:
> Remove duplicate "make RECORDMCOUNT_WARN=1" description from "make help" output
>
> Signed-off-by: Jongman Heo <jongman.heo@gmail.com>
> ---
>  Makefile |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 2652089..86437a3 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1290,7 +1290,6 @@ help:
>        @echo  '  make O=dir [targets] Locate all output files in "dir",
> including .config'
>        @echo  '  make C=1   [targets] Check all c source with $$CHECK
> (sparse by default)'
>        @echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
> -       @echo  '  make RECORDMCOUNT_WARN=1 [targets] Warn about ignored
> mcount sections'
>        @echo  '  make W=n   [targets] Enable extra gcc checks, n=1,2,3 where'
>        @echo  '                1: warnings which may be relevant and do not occur too often'
>        @echo  '                2: warnings which occur quite often but may still be relevant'
> --
> 1.7.6.4
>

Sorry for the unwanted line wrapping, I couldn't find a way to disable
automatic line wrapping of gmail.

But this is simple, one-liner patch, hope it's fine.

Regards,
jongman.
