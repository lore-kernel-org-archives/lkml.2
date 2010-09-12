Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0ILQSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 12:18:10 -0400
Received: from ist.d-labs.de ([213.239.218.44]:57111 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab0ILQSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 12:18:09 -0400
Date: Sun, 12 Sep 2010 18:18:06 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] Documentation/SubmittingPatches: Add and describe
 scripts/get_maintainer.pl
Message-ID: <20100912181806.43e2bd2b@schatten.dmk.lab>
In-Reply-To: <1284234211.12180.106.camel@Joe-Laptop>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
 <1284111767.1783.35.camel@Joe-Laptop>
 <20100910095259.GC23903@sirena.org.uk>
 <1284113066.1783.69.camel@Joe-Laptop>
 <20100910101818.GF3068@rakim.wolfsonmicro.main>
 <1284115665.1783.144.camel@Joe-Laptop>
 <1284164541.1783.204.camel@Joe-Laptop>
 <20100911113811.7c685c6d@schatten.dmk.lab>
 <1284198750.12180.18.camel@Joe-Laptop>
 <20100911120243.7cce451e@schatten.dmk.lab>
 <1284232943.12180.97.camel@Joe-Laptop>
 <1284234211.12180.106.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Sep 2010 12:43:31 -0700
Joe Perches <joe@perches.com> wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  Documentation/SubmittingPatches |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index 689e237..bb318f9 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -176,6 +176,23 @@ discussed should the patch then be submitted to Linus.
>  
>  6) Select your CC (e-mail carbon copy) list.
>  
> +Use
> +	"./scripts/get_maintainer.pl --nogit --roles <patch>"
> +to find the appropriate maintainers and mailing lists to CC.
> +
> +If the output email addresses doesn't show a "supporter" or "maintainer",
> +you can expand the search to include git history with:
> +
> +	"./scripts/get_maintainer.pl --roles <patch>"
> +
> +Searching git history can often list individuals that may not be
> +particularly interested in your patch, so use the list of names
> +judiciously.
> +
> +./scripts/get_maintainer.pl options "--rolestats" and "--git-blame"
> +can show a bit more information and might help you select the appropriate
> +parties to CC.
> +
>  Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org.
>  
>  Other kernel developers besides Linus need to be aware of your change,
> 
> 

That is more to the point. I.e. it tackles the same problem
as my patch: The communication disconnect between sender and receiver.

But I'm a bit sceptical at how efficient this is. 

Cheers,
Flo

