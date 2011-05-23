Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1EWQLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:11:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1858 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab1EWQLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:11:47 -0400
Subject: Re: [patch v3] checkpatch: Signature format verification
From: Joe Perches <joe@perches.com>
To: anish <anish198519851985@gmail.com>
Cc: davej@redhat.com, rostedt@goodmis.org, apw@shadowen.org,
        akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
In-Reply-To: <1306164094.2292.25.camel@anish-desktop>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
	 <1306164094.2292.25.camel@anish-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 09:11:45 -0700
Message-ID: <1306167105.8687.11.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 20:51 +0530, anish wrote:
> From: anish kumar <anish198519851985@gmail.com>
> This patch generates warning when there is no space between
> the patch submitter and successive mail-id.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> +				if (!($line =~ /^\s*$sign/)) {

				if  ($line !~ /etc...)

> +					WARN("$sign is the preferred form\n" .
> +						$herecurr);
> +				}
> +				if ($line =~ /^\s*$sign(.*)/i) {
> +					if($1 !~ /^\s*(\s[a-zA-Z]*.*)/i) {

Email addresses may start with a quote (") or a digit.

Space between if and (

> +						WARN("Space required after $sign\n" .
> +							$herecurr);
> +					}
> +					if($1 !~ /[\sa-zA-Z]+\s<.*>/i) {

Space between if and (


