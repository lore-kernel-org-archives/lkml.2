Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab3AJFw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 00:52:59 -0500
Received: from gate.crashing.org ([63.228.1.57]:34482 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab3AJFw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 00:52:58 -0500
Message-ID: <1357796898.4838.85.camel@pasglop>
Subject: Re: [TRIVIAL PATCH 11/26] powerpc: Convert print_symbol to %pSR
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Joe Perches <joe@perches.com>, Jiri Kosina <trivial@kernel.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Jan 2013 16:48:18 +1100
In-Reply-To: <201212131158.46055.arnd@arndb.de>
References: <cover.1355335227.git.joe@perches.com>
	 <8c901014a0f571011023ed98b9a22bc690925b73.1355335228.git.joe@perches.com>
	 <201212131158.46055.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-13 at 11:58 +0000, Arnd Bergmann wrote:
> On Wednesday 12 December 2012, Joe Perches wrote:
> > Use the new vsprintf extension to avoid any possible
> > message interleaving.
> > 
> > Convert the #ifdef DEBUG block to a single pr_debug.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> nice cleanup!

 ... which also breaks the build :-(

> Acked-by: Arnd Bergmann <arnd@arndb.de>

I'll fix it up locally.

Ben.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


