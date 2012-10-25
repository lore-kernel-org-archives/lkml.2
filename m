Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab2JYAb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:31:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55600 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751284Ab2JYAbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:31:25 -0400
Message-ID: <1351125084.7130.16.camel@joe-AO722>
Subject: Re: [PATCH 03/23] printk: Move braille console support into
 separate braille.[ch] files
From: Joe Perches <joe@perches.com>
To: Stephen Warren <swarren@wwwdotorg.org>, Ming Lei <tom.leiming@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Date: Wed, 24 Oct 2012 17:31:24 -0700
In-Reply-To: <508883D6.70706@wwwdotorg.org>
References: <cover.1350449851.git.joe@perches.com>
	 <592f6af296db3e82a392252b3a7c8a7b1020194d.1350449851.git.joe@perches.com>
	 <508883D6.70706@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 18:12 -0600, Stephen Warren wrote:
> On 10/17/2012 12:06 AM, Joe Perches wrote:
> > Create files with prototypes and static inlines for braille
> > support.  Make braille_console functions return 1 on success.
> 
> Joe,
> 
> Between next-20121022 and next-20121023, the serial console (on the ARM
> SoC Tegra at least) stopped working. The issue bisects down to this
> commit. I haven't had a chance to investigate why yet, I just finished
> bisected.
> 
> earlyprintk over the same UART works. Once the system has booted, a few
> late kernel messages do appear, and then getty/login over the UART
> works. So, it's just the printk messages that disappeared.
> 
> In case it's relevant, my command-line is:
> 
> console=ttyS0,115200n8 loglevel=8 rootwait rw earlyprintk
> root=PARTUUID=b2f82cda-2535-4779-b467-094a210fbae7
> 
> I'll continue to investigate further tomorrow, but just wanted to give
> you a heads-up in case you could immediately see anything obvious in the
> code.

Hi Stephen.

Thanks, I appreciate the heads-up.  This should be solved
by Ming Lei's patch (which I've incorporated into a V2
series I will post shortly).

https://lkml.org/lkml/2012/10/23/307


