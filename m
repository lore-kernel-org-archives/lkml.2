Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab0JMJfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 05:35:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:35855 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab0JMJf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 05:35:29 -0400
Message-ID: <4CB57D5F.8070404@suse.cz>
Date: Wed, 13 Oct 2010 11:35:27 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/get_maintainer.pl: Make --rolestats the default
References: <74352a858e9e82ca186505aabdcc8ea2e8a7c0c8.1286921484.git.joe@perches.com>
In-Reply-To: <74352a858e9e82ca186505aabdcc8ea2e8a7c0c8.1286921484.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.10.2010 00:14, Joe Perches wrote:
> This script now requires a user to add --norolestats
> to the command line so it's harder to feed the output
> of this script to programs that send mass emails.

Good idea, hopefully this will make people spend some time looking at
the CC list and removing the innocent :-).


> Update --help to correct command line defaults.
> 
> Change version to 0.26.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Michal Marek <mmarek@suse.cz>


> ---
>  scripts/get_maintainer.pl |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index d21ec3a..43bace2 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -13,7 +13,7 @@
>  use strict;
>  
>  my $P = $0;
> -my $V = '0.26-beta6';
> +my $V = '0.26';
>  
>  use Getopt::Long qw(:config no_auto_abbrev);
>  
> @@ -40,7 +40,7 @@ my $email_use_mailmap = 1;
>  my $output_multiline = 1;
>  my $output_separator = ", ";
>  my $output_roles = 0;
> -my $output_rolestats = 0;
> +my $output_rolestats = 1;
>  my $scm = 0;
>  my $web = 0;
>  my $subsystem = 0;
> @@ -720,7 +720,8 @@ Other options:
>    --help => show this help information
>  
>  Default options:
> -  [--email --git --m --n --l --multiline --pattern-depth=0 --remove-duplicates]
> +  [--email --nogit --git-fallback --m --n --l --multiline -pattern-depth=0
> +   --remove-duplicates --rolestats]
>  
>  Notes:
>    Using "-f directory" may give unexpected results:

