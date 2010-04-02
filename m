Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0DBQL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 12:11:26 -0400
Received: from xenotime.net ([72.52.64.118]:38005 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752168Ab0DBQLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:11:19 -0400
Date: Fri, 2 Apr 2010 09:11:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <gregkh@suse.de>, David Miller <davem@davemloft.net>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: -stable rules: upstream commit ID
 requirement reworded
Message-Id: <20100402091118.912a0a17.rdunlap@xenotime.net>
In-Reply-To: <tkrat.768beea282d5d26b@s5r6.in-berlin.de>
References: <20100331215332.GH7671@dastard>
	<20100331224755.GA23284@suse.de>
	<20100401044048.GD16238@1wt.eu>
	<20100401.002622.179174704.davem@davemloft.net>
	<4BB4823F.7040408@s5r6.in-berlin.de>
	<20100401153547.GB12944@suse.de>
	<tkrat.768beea282d5d26b@s5r6.in-berlin.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010 22:01:52 +0200 (CEST) Stefan Richter wrote:

> It is a hard requirement to include the upstream commit ID in the
> changelog of a -stable submission, not just a courtesy to the stable
> team.  This concerns only mail submission though, which is no longer
> the only way into stable.  (Also, fix a double "the".)
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Looks good to me.  Thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> ---
>  Documentation/stable_kernel_rules.txt |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> Index: b/Documentation/stable_kernel_rules.txt
> ===================================================================
> --- a/Documentation/stable_kernel_rules.txt
> +++ b/Documentation/stable_kernel_rules.txt
> @@ -18,16 +18,15 @@ Rules on what kind of patches are accept
>   - It cannot contain any "trivial" fixes in it (spelling changes,
>     whitespace cleanups, etc).
>   - It must follow the Documentation/SubmittingPatches rules.
> - - It or an equivalent fix must already exist in Linus' tree.  Quote the
> -   respective commit ID in Linus' tree in your patch submission to -stable.
> + - It or an equivalent fix must already exist in Linus' tree (upstream).
>  
>  
>  Procedure for submitting patches to the -stable tree:
>  
>   - Send the patch, after verifying that it follows the above rules, to
> -   stable@kernel.org.
> - - To have the patch automatically included in the stable tree, add the
> -   the tag
> +   stable@kernel.org.  You must note the upstream commit ID in the changelog
> +   of your submission.
> + - To have the patch automatically included in the stable tree, add the tag
>       Cc: stable@kernel.org
>     in the sign-off area. Once the patch is merged it will be applied to
>     the stable tree without anything else needing to be done by the author


---
~Randy
