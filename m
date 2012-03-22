Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2CVKRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:17:48 -0400
Received: from hulk.biessmann.org ([62.75.166.25]:38134 "EHLO
	hulk.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab2CVKRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:17:46 -0400
Date: Thu, 22 Mar 2012 11:17:19 +0100
From: Andreas =?iso-8859-1?Q?Bie=DFmann?= <andreas@biessmann.de>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Michal Marek <mmarek@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86, build: remove unused include
Message-ID: <20120322101719.GC1406@localhost>
References: <1329324589-26907-1-git-send-email-andreas@biessmann.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1329324589-26907-1-git-send-email-andreas@biessmann.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SPAM_bar: --
X-SPAM_score: -28
X-ChkData-Signature: 3bad601bfe40790bdc6d658c545eeec0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 05:49:49PM +0100, Andreas Bieﬂmann wrote:
> Commit 079f85e624189292d1c818b47764916bf8cf84a8 removed necessity for
> sys/sysmacros.h include but missed to remove the include.
> 
> Still requiring sys/sysmacros.h for build tool breaks cross compiling x86 kernel
> on non linux style systems which may not offer sys/sysmacros.h.
> 
> Signed-off-by: Andreas Bieﬂmann <andreas@biessmann.de>
> ---
>  arch/x86/boot/tools/build.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
> index 4e9bd6b..52628cd 100644
> --- a/arch/x86/boot/tools/build.c
> +++ b/arch/x86/boot/tools/build.c
> @@ -29,7 +29,6 @@
>  #include <stdarg.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> -#include <sys/sysmacros.h>
>  #include <unistd.h>
>  #include <fcntl.h>
>  #include <sys/mman.h>
> -- 

are there any objections against that patch? could anyone take it if not?
