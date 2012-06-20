Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab2FTQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:25:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43901 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754355Ab2FTQZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:25:27 -0400
Message-ID: <1340209526.29885.14.camel@joe2Laptop>
Subject: Re: [PATCH] scripts/get_maintainer.pl: Add tested-by signature
From: Joe Perches <joe@perches.com>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Florian Mickler <florian@mickler.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Date: Wed, 20 Jun 2012 09:25:26 -0700
In-Reply-To: <1340193105-10734-1-git-send-email-aletes.xgr@gmail.com>
References: <1340193105-10734-1-git-send-email-aletes.xgr@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 08:51 -0300, Alexandre Pereira da Silva wrote:
> The tester of the patch should also be listed to receive patch
> notifications.
[]
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
[]
> @@ -81,6 +81,7 @@ my $penguin_chiefs = "\(" . join("|", @penguin_chief_names) . "\)";
>  my @signature_tags = ();
>  push(@signature_tags, "Signed-off-by:");
>  push(@signature_tags, "Reviewed-by:");
> +push(@signature_tags, "Tested-by:");
>  push(@signature_tags, "Acked-by:");

I have no objections to this, but maybe Florian Mickler
(cc'd) who did analysis on signatures awhile ago might.



