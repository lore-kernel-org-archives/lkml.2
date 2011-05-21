Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab1EUTwr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 15:52:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1836 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab1EUTwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 15:52:45 -0400
Subject: Re: PATCH] patch to generate warning when signed-of line in patch
 in not proper
From: Joe Perches <joe@perches.com>
To: anish <anish198519851985@gmail.com>
Cc: davej@redhat.com, rostedt@goodmis.org, apw@shadowen.org,
        akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
In-Reply-To: <1306006721.1622.18.camel@anish-desktop>
References: <1306006721.1622.18.camel@anish-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 May 2011 12:52:44 -0700
Message-ID: <1306007564.2068.54.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-22 at 01:08 +0530, anish wrote:
> On Sat, May 21, 2011 at 9:33 PM, Joe Perches <joe@perches.com> wrote:
> >>If you do this, why not do it for all signature types?
> >>our $Valid_Signatures "(?:Signed-off-by:|Reviewed-by:|Acked-by:)"
> Definitely.Please check below modified patch.
[]
> This patch generates warning when there is no space betweenthe  patch
> submitter name and successive mail-id.As suggested by
> Joe Perches(joe@perches.com) that we can do this for
> all signature types.

Typos and spacing issues in commit message.

> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> +my $sign;
> +my @signs = ("Reviewed-by:","Acked-by:","Signed-off-by:","Tested-by:");
[]
> +#check the patch for a signoff/Reviewed/Acked/Tested:
> +        foreach $sign (@signs) {

It's inefficient to loop for this.
I think what I suggested is neater,
but what you're doing is OK.

Your email subject line should be more like:

[PATCH] checkpatch: More signature format verification

And when you revise patches, use some version number
in the [PATCH] block like:

[PATCH v2] checkpatch: etc...

cheers, Joe

