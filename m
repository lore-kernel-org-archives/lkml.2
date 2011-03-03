Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab1CCPYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 10:24:03 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:44245 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190Ab1CCPYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 10:24:01 -0500
Date: Thu, 3 Mar 2011 16:23:49 +0100
From: Harald Welte <laforge@gpl-violations.org>
To: Armijn Hemel <armijn@gpl-violations.org>
Cc: Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        linux-kernel@vger.kernel.org, James Morris <jmorris@intercode.com.au>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: changing EXPORT_SYMBOL_GPL to EXPORT_SYMBOL in DD-WRT
Message-ID: <20110303152349.GL8117@prithivi.gnumonks.org>
References: <1299164159.10725.19.camel@hibbert>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299164159.10725.19.camel@hibbert>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian, Armijn and others,

I can only follow what Armijn has been writing.

On Thu, Mar 03, 2011 at 03:55:59PM +0100, Armijn Hemel wrote:
> I noticed that a few hours ago you changed a few lines in the kernel
> source of DD-WRT, changing the export from a few symbols from 'GPL only'
> to something a lot more permissive:

While the ideas and thoughts regarding the legal implications of
EXPORT_SYMBOL_GPL are wide (see e.g. http://lwn.net/Articles/154602/) and there
is no precedent as far as I know, there seems general consensus that it _at
least_ signifies the explicit intent of the author.

By using the _GPL variant, the author unmistakingly indicates: 
"I consider any use of that symbol to create a derivative work which must again
 be licensed under GNU GPL"

So by modifying a _GPL symbol into the non-GPL variant (and using the code from
a non-GPL module), one would clearly violate the intent of the original author.
Whether or not that intent of the author is grounded in copyright law may
depend on the specific jurisdiction, circumstances and the judge that would
make up his mind about it, if such a case ever went to court.

I would be interested to hear what DaveM, James Morris and Herbert Xu
as the authors of the files in question have to say about such activity.

Regards,
	Harald
-- 
- Harald Welte <laforge@gpl-violations.org>       http://gpl-violations.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
