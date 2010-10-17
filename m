Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab0JQKUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 06:20:15 -0400
Received: from canuck.infradead.org ([134.117.69.58]:34923 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab0JQKUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 06:20:14 -0400
Subject: Re: [PATCH] checkpatch: allow single space before labels
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
References: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Oct 2010 12:20:09 +0200
Message-ID: <1287310809.1998.152.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 04:05 -0400, Mike Frysinger wrote:

NACK!

Use:

QUILT_DIFF_OPTS="-F ^[[:alpha:]\$_].*[^:]\$"


> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  scripts/checkpatch.pl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 2039acd..1d06df7 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1459,7 +1459,7 @@ sub process {
>  		}
>  
>  # check for spaces at the beginning of a line.
> -		if ($rawline =~ /^\+ / && $rawline !~ /\+ +\*/)  {
> +		if ($rawline =~ /^\+ / && $rawline !~ /\+ +\*/ && $rawline !~ /:$/)  {
>  			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
>  			WARN("please, no space for starting a line, \
>  				excluding comments\n" . $herevet);


