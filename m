Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab1AXXxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:53:49 -0500
Received: from mail.perches.com ([173.55.12.10]:3284 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab1AXXxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:53:48 -0500
Subject: Re: [PATCH] get_maintainer.pl: Add support to match arbitrary text
From: Joe Perches <joe@perches.com>
To: "L. Alberto" =?ISO-8859-1?Q?Gim=E9nez?= <agimenez@sysvalve.es>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Mickler <florian@mickler.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>
In-Reply-To: <1295911951-12615-1-git-send-email-agimenez@sysvalve.es>
References: <1295911951-12615-1-git-send-email-agimenez@sysvalve.es>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 15:53:46 -0800
Message-ID: <1295913226.3101.60.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 00:32 +0100, L. Alberto Giménez wrote:
> Extend the usage of the K section in the MAINTAINERS file to support matching
> regular expressions with the content that precedes the patch (delimited by three
> dashes "---").
> +		} elsif (not $in_patch and m/^---/) {
> +			# enter "patch area": keywords matched only on changed lines
> +			$in_patch = 1;

Not all patches need or have ---

This would be better as "^---$"


