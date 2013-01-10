Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3AJRA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:00:57 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57508 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751041Ab3AJRAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:00:54 -0500
Message-ID: <1357837252.2894.6.camel@joe-AO722>
Subject: Re: [TRIVIAL PATCH 11/26] powerpc: Convert print_symbol to %pSR
From: Joe Perches <joe@perches.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jiri Kosina <trivial@kernel.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Jan 2013 09:00:52 -0800
In-Reply-To: <1357796898.4838.85.camel@pasglop>
References: <cover.1355335227.git.joe@perches.com>
	 <8c901014a0f571011023ed98b9a22bc690925b73.1355335228.git.joe@perches.com>
	 <201212131158.46055.arnd@arndb.de> <1357796898.4838.85.camel@pasglop>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-10 at 16:48 +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2012-12-13 at 11:58 +0000, Arnd Bergmann wrote:
> > On Wednesday 12 December 2012, Joe Perches wrote:
> > > Use the new vsprintf extension to avoid any possible
> > > message interleaving.
> > > 
> > > Convert the #ifdef DEBUG block to a single pr_debug.
> > > 
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > 
> > nice cleanup!
> 
>  ... which also breaks the build :-(
> 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> I'll fix it up locally.

OK, I didn't compile it.
How does it break the build?

