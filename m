Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2EBPcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:32:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51102 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab2EBPcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:32:15 -0400
Date: Wed, 2 May 2012 16:32:12 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: checkpatch: brackets around single statements fix
Message-ID: <20120502153212.GE3364@shadowen.org>
References: <20120502151046.GA25573@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502151046.GA25573@tsunami.ccur.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 11:10:46AM -0400, Joe Korty wrote:
> Checkpatch thinks '#else' is the same as 'else' in its check for
> this error:
> 
>    WARNING: braces {} are not necessary for single statement blocks
> 
> Signed-off-by: Joe Korty <joe.korty@ccur.com>
> 
> Index: linux/scripts/checkpatch.pl
> ===================================================================
> --- linux.orig/scripts/checkpatch.pl	2012-04-17 05:00:37.000000000 -0400
> +++ linux/scripts/checkpatch.pl	2012-05-02 10:29:03.000000000 -0400
> @@ -3038,7 +3038,7 @@
>  			}
>  		}
>  		if (!defined $suppress_ifbraces{$linenr - 1} &&
> -					$line =~ /\b(if|while|for|else)\b/) {
> +					$line =~ /[^#]\b(if|while|for|else)\b/) {
>  			my $allowed = 0;
>  
>  			# Check the pre-context.

Interesting.  Got an example I can use to add to the test suite.

-apw
