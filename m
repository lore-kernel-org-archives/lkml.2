Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2ECD6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 23:58:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47747 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753305Ab2ECD63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 23:58:29 -0400
Message-ID: <1336017507.13866.2.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: add check for whitespace before semicolon
 at end-of-line
From: Joe Perches <joe@perches.com>
To: Eric Nelson <eric.nelson@boundarydevices.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        u-boot@lists.denx.de, rylv50@freescale.com, marex@denx.de,
        vapier@gentoo.org
Date: Wed, 02 May 2012 20:58:27 -0700
In-Reply-To: <1336015938-3174-1-git-send-email-eric.nelson@boundarydevices.com>
References: <http://lists.denx.de/pipermail/u-boot/2012-May/123595.html>
	 <1336015938-3174-1-git-send-email-eric.nelson@boundarydevices.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 20:32 -0700, Eric Nelson wrote:
> This tests for a bad habits of mine like this:
> 
> 	return 0 ;
> 
> Signed-off-by: Eric Nelson <eric.nelson@boundarydevices.com>
> ---
>  scripts/checkpatch.pl |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index a3b9782..0e6977e 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3227,6 +3227,12 @@ sub process {
>  			 "Statements terminations use 1 semicolon\n" . $herecurr);
>  		}
>  
> +# check for whitespace before semicolon - not allowed at end-of-line
> +		if ($line =~ /\s+;$/) {

		if ($line =~ /\s+;\s*$/)

> +		    WARN("SPACEBEFORE_SEMICOLON",

		    WARN("SPACING",
	
> +			 "Whitespace before semicolon\n" . $herecurr);
> +		}
> +


