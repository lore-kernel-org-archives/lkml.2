Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab2LEPW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:22:56 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53495 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2LEPWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:22:54 -0500
Date: Wed, 5 Dec 2012 15:27:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Borislav Petkov <bp@alien8.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
        Li Shaohua <shaohua.li@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: Look Ma, da kernel is b0rken
Message-ID: <20121205152756.5afec12c@pyramind.ukuu.org.uk>
In-Reply-To: <20121205142935.GA12119@liondog.tnic>
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
	<20121205142935.GA12119@liondog.tnic>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2012 15:29:35 +0100
Borislav Petkov <bp@alien8.de> wrote:

> On Wed, Dec 05, 2012 at 08:09:01AM +0100, Andreas Mohr wrote:
> > Hi,
> > 
> > drivers/pnp/pnpacpi/core.c: In function 'ispnpidacpi':
> > drivers/pnp/pnpacpi/core.c:65:2: warning: logical 'or' of collectively
> > exhaustive tests is always true [-Wlogical-op]
> > drivers/pnp/pnpacpi/core.c:66:2: warning: logical 'or' of collectively
> > exhaustive tests is always true [-Wlogical-op]
> > drivers/pnp/pnpacpi/core.c:67:2: warning: logical 'or' of collectively
> > exhaustive tests is always true [-Wlogical-op]
> > 
> > 
> > That's already the second less enticing -Wlogical-op issue
> > which was discovered by accident during less than two days

No it's not. It's been reported in bugzilla. I sent patches ages ago.
They were ignored. Coverity has had it tagged for years (and a ton more
of them you've not noticed yet)

http://article.gmane.org/gmane.linux.acpi.devel/56753/match=test_alpha

This isn't discovered, this is in the "If you stick your fingers in your
ears and hum you can't hear the screaming" category.

Alan
