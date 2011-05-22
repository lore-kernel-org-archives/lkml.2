Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1EVOQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 10:16:19 -0400
Received: from mail.perches.com ([173.55.12.10]:1844 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479Ab1EVOQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 10:16:14 -0400
Subject: Re: [patch v2] checkpatch: Signature format verification
From: Joe Perches <joe@perches.com>
To: anish <anish198519851985@gmail.com>
Cc: davej@redhat.com, rostedt@goodmis.org, apw@shadowen.org,
        akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
In-Reply-To: <1306059528.2761.3.camel@anish-desktop>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 07:16:12 -0700
Message-ID: <1306073772.1681.6.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-22 at 15:48 +0530, anish wrote:
> This patch generates warning when there is no space between
> the patch submitter and successive mail-id.
[]
> Signed-off-by: anish kumar <anish198519851985@gmail.com>
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index d867081..0622f41 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -29,6 +29,8 @@ my $summary_file = 0;
>  my $root;
>  my %debug;
>  my $help = 0;
> +my ($sign,$loop_brk);

These 2 variables don't need to be at this scope.

> @@ -1365,20 +1367,30 @@ sub process {
[]
> +#check the patch for a signoff/Reviewed/Acked/Tested:
> +foreach $sign (@signs) {

Please use the appropriate indentation or add a new function.


