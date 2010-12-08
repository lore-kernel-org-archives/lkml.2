Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab0LHXlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:41:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:45009 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab0LHXlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:41:23 -0500
Subject: Re: linux-next: Tree for December 8
 (drivers/platform/x86/Kconfig:422:error: recursive dependency detected!)
From: David Woodhouse <dwmw2@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>, sedat.dilek@gmail.com,
        Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 08 Dec 2010 23:41:16 +0000
In-Reply-To: <20101208153428.93c95c54.randy.dunlap@oracle.com>
References: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com>
	 <AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
	 <1291801990.5992.105.camel@i7.infradead.org>
	 <20101208174603.GA7107@core.coreip.homeip.net>
	 <20101208135105.a8482d46.randy.dunlap@oracle.com>
	 <1291849721.5992.145.camel@i7.infradead.org>
	 <20101208153428.93c95c54.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.3 
Content-Transfer-Encoding: 7bit
Message-ID: <1291851677.5992.151.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 15:34 -0800, Randy Dunlap wrote:
> xconfig has options that show all symbols.  I use that most of the time,
> but I bet that most people do not.

That just means that 'select' is *completely* pointless and stupid,
rather than being a lazy workaround for broken tools.

Time to remove it *entirely*, perhaps?

-- 
dwmw2

