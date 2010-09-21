Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab0IUAOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 20:14:48 -0400
Received: from mail.perches.com ([173.55.12.10]:2160 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab0IUAOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 20:14:47 -0400
Subject: Re: [PATCH] scripts/get_maintainer.pl: fix .mailmap handling
From: Joe Perches <joe@perches.com>
To: florian@mickler.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, greg@kroah.com,
        stefanr@s5r6.in-berlin.de, broonie@opensource.wolfsonmicro.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>
In-Reply-To: <1285022156-14501-1-git-send-email-florian@mickler.org>
References: <1285021645-14311-1-git-send-email-florian@mickler.org>
	 <1285022156-14501-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 17:14:45 -0700
Message-ID: <1285028085.25988.60.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 00:35 +0200, florian@mickler.org wrote:
> From: florian@mickler.org <florian@mickler.org>
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl

[]

> -	my ($name, $address) = parse_email($line);
> -	$line = format_email($name, $address, $email_usename);
> +	next if (/^\s*$/); #skip empty lines
> +	#print "entry: \"$_\"\n";

Please do not add commented out debugging code.
Add and use use some centralized debug(foo) call.

[]

> +sub mailmap {
> +    my (@addresses) = @_;
> +
> +    my @ret = ();

Suboptimal naming.  I try to use descriptive names.

cheers, Joe

