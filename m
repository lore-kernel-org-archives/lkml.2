Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1GZOqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:46:33 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52026 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1GZOq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:46:27 -0400
MIME-Version: 1.0
In-Reply-To: <1310520405-1558-2-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1310520405-1558-1-git-send-email-Gregory.Dietsche@cuw.edu>
	<1310520405-1558-2-git-send-email-Gregory.Dietsche@cuw.edu>
Date: Tue, 26 Jul 2011 16:46:26 +0200
X-Google-Sender-Auth: ZiRC0NJTsclfteq7dyFZrbL_D8g
Message-ID: <CAAxaTiNvF1GO2rMSHwRnn4SrDpRNm54y0ma6qyPoJwKGMyEAXQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] coccinelle.txt: add overview section
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
> Add an overview section to the Coccinelle documentation.
>
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>

Signed-off-by: Nicolas Palix <npalix.work@gmail.com>

> ---
>  Documentation/coccinelle.txt |   31 +++++++++++++++++++++++++++++++
>  1 files changed, 31 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
> index 96b6903..9495a4b 100644
> --- a/Documentation/coccinelle.txt
> +++ b/Documentation/coccinelle.txt
> @@ -41,6 +41,37 @@ The semantic patches in the kernel will work best with Coccinelle version
>  semantic patch code, but any results that are obtained should still be
>  correct.
>
> +
> + Overview / Quick Start
> +~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +There are two ways to use Coccinelle with the Linux kernel.
> +
> +1) Coccinelle can be used like sparse (see Documentation/sparse.txt):
> +       make C=1 CHECK="scripts/coccicheck"
> +       make C=2 CHECK="scripts/coccicheck"
> +
> +2) Coccinelle can be used via a build target in the kernel's Makefile:
> +       make coccicheck
> +
> +There are a number of optional parameters that can be used with the build target.
> +
> +       make coccicheck MODE={patch,report,context,org} COCCI=? M=?
> +
> +MODE:
> +       Determines what mode cocci operates in. If no mode is specified
> +       then cocci will default to 'chain' mode which will run for each
> +       available mode (patch, report, context, org).
> +
> +COCCI:
> +       Process a specific .cocci SmPL script. If this is not set then
> +       process all scripts under scripts/coccinelle/
> +
> +M:
> +       Limit cocci to a subset of directories. This is very similar to the
> +       way the build system works when building modules.
> +
> +
>  Using Coccinelle on the Linux kernel
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> --
> 1.7.2.5
>
>



-- 
Nicolas Palix
http://sardes.inrialpes.fr/~npalix/
