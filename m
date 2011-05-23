Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab1EWRSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:18:40 -0400
Received: from mail.perches.com ([173.55.12.10]:1891 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab1EWRSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:18:39 -0400
Subject: Re: [patch v3] checkpatch: Signature format verification
From: Joe Perches <joe@perches.com>
To: anish singh <anish198519851985@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, davej@redhat.com, rostedt@goodmis.org,
        apw@shadowen.org, akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
In-Reply-To: <BANLkTik8coVxt=Z92NQBNH_=4yRhTtexzA@mail.gmail.com>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
	 <1306164094.2292.25.camel@anish-desktop>
	 <1306167105.8687.11.camel@Joe-Laptop>
	 <BANLkTi=9nzMbxU0=P+pOaHcebqhL=bd2HQ@mail.gmail.com>
	 <1306168598.8687.27.camel@Joe-Laptop>
	 <20110523093920.8f1e5cd0.rdunlap@xenotime.net>
	 <1306168975.8687.29.camel@Joe-Laptop>
	 <BANLkTik8coVxt=Z92NQBNH_=4yRhTtexzA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 10:18:37 -0700
Message-ID: <1306171117.8687.34.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 22:36 +0530, anish singh wrote:
>  if ($1 !~ /[\sa-zA-Z\"]*\s<.*>/i) {
>  WARN("Space required b/w Full Name & Mail-id:\n" .
>                                                         $herecurr);
>                                         }
> Quote has been taken care too now.

If you're going to try to validate email addresses,
please do it reasonably correctly or not at all.

At a minimum you need to add digits, single quote,
period, and comma.

Look at git-send-email.perl or scripts/get_maintainer.pl
for email address validation samples.


